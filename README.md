# RunRun Realtime Monitoring Architecture

Arquitetura de monitoramento em tempo quase real para atividades do RunRun.it.

## Problema

Ferramentas SaaS nem sempre garantem consistência de estado em tempo real.
Eventos podem falhar, usuários podem desconectar sem pause, gerando tarefas "fantasma".

Este projeto resolve:

- Monitoramento confiável de tarefas ativas
- Reconciliação automática de inconsistências
- Histórico completo de eventos play/pause
- Camada dimensional para BI

## Arquitetura

Webhook → runrun_raw → staging → analytics → snapshot → Metabase

Reconciliação periódica via API:
GET /tasks?is_working_on=true

## Stack

- PostgreSQL (Supabase)
- n8n
- RunRun Webhooks
- RunRun REST API
- Metabase

## Modelo

Camadas:
- raw (append-only)
- staging (normalização)
- analytics (modelo estrela)
- snapshot operacional separado da fato

## Funcionalidades

- Estado atual confiável
- Histórico auditável
- Guard contra pause duplicado
- Monitoramento de inconsistências
- View pronta para BI

## Roadmap

- SCD para usuários
- Fato de tempo acumulado
- Alertas automáticos

## Credenciais RunRun API

O fluxo `n8n/[RunRun] [Tasks Working On Guarantee].json` envia os cabeçalhos `App-Key` e `User-Token` para garantir a reconciliação das tarefas. Em vez de deixar esses valores dentro do JSON, preencha as variáveis de ambiente `RUNRUN_APP_KEY` e `RUNRUN_USER_TOKEN` no arquivo `.env` na raiz (este arquivo já está no `.gitignore`). O n8n procura as variáveis em tempo de execução e o nó `TAREFAS TRABALHANDO` acessa os valores com as expressões `{{$env.RUNRUN_APP_KEY}}` e `{{$env.RUNRUN_USER_TOKEN}}`.

```env
RUNRUN_APP_KEY=<sua app key aqui>
RUNRUN_USER_TOKEN=<seu user token aqui>
```

Carregue o `.env` antes de iniciar o n8n (por exemplo, executando `n8n` a partir de um terminal que já tenha as variáveis no ambiente). Mantenha esse arquivo fora do controle de versão e nunca compartilhe as chaves reais nos workflows exportados.

## Orquestração (n8n Workflows)

Este projeto inclui workflows reais exportados do n8n, organizados na pasta `/n8n`.

### 1. Raw → Staging (Boards, Projects, Users)

Arquivo:
[RunRun] [Boards, Projects, Users] Raw -> Staging  
:contentReference[oaicite:0]{index=0}

Função:
- Schedule a cada 3 horas
- Atualiza staging.boards
- Atualiza staging.projects
- Atualiza staging.users
- Estratégia baseada em `distinct on (id)` + controle por `_airbyte_extracted_at`

---

### 2. Reconciliação de Estado

Arquivo:
[RunRun] [Tasks Working On Guarantee]  
:contentReference[oaicite:1]{index=1}

Função:
- Executa a cada 1 minuto
- Chama API `GET /tasks?is_working_on=true`
- Compara com snapshot `task_current_state`
- Insere pause forçado quando necessário
- Evita duplicação via guard de 2 minutos
- Dispara workflow de atualização analítica

---

### 3. Atualização Analytics (Staging → Analytics)

Arquivo:
[RunRun] ACTIVE_USERS | Staging -> Analytics  
:contentReference[oaicite:2]{index=2}

Função:
- UPSERT dim_users
- UPSERT dim_boards
- UPSERT dim_tasks
- INSERT idempotente em f_task_events
- Atualização de snapshot operacional

---

### 4. Webhook PLAY

Arquivo:
[RunRun] Running Tasks: PLAY task_events - WebHook  
:contentReference[oaicite:3]{index=3}

Função:
- Recebe evento `play`
- INSERT em raw
- Atualiza staging
- Dispara reconciliação

---

### 5. Webhook PAUSE

Arquivo:
[RunRun] Running Tasks: PAUSE task_events - WebHook  
:contentReference[oaicite:4]{index=4}

Função:
- Recebe evento `pause`
- INSERT em raw
- Atualiza staging
- Dispara reconciliação
