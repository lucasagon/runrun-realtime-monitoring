# Arquitetura — RunRun Realtime Monitoring

## 1. Visão Geral

Arquitetura de dados orientada a eventos para monitoramento quase em tempo real de tarefas do RunRun.it.

O sistema garante:

- Histórico completo e auditável
- Snapshot consistente do estado atual
- Reconciliação automática de inconsistências
- Modelo dimensional pronto para BI

---

## 2. Arquitetura em Camadas (Medallion)

runrun_raw → runrun_staging → runrun_analytics → Snapshot → BI

### Camada Raw
- Fonte de verdade
- Append-only
- Payload completo em JSONB
- Sem regra de negócio

### Camada Staging
- Normalização do JSON
- Tipagem explícita
- Deduplicação por raw_id
- Preparação para analytics

### Camada Analytics
- Modelo estrela
- Surrogate keys
- Fato histórica desacoplada
- Snapshot operacional separado

---

## 3. Fluxo de Dados

### Ingestão via Webhook

1. Webhook recebe evento (play/pause)
2. INSERT em runrun_raw.task_events
3. Transformação raw → staging
4. Atualização de dimensões
5. INSERT na fato
6. Atualização do snapshot

---

### Reconciliação via API

Executada a cada 1 minuto:

1. GET /tasks?is_working_on=true
2. Compara com snapshot atual
3. Insere pause forçado quando necessário
4. Reprocessa pipeline

---

## 4. Decisões Arquiteturais

### Raw é imutável
Permite rebuild completo do sistema.

### Snapshot separado da fato
Evita window functions em consultas operacionais.
Garante baixa latência para BI.

### Reconciliação ativa
Sistemas event-driven não garantem consistência perfeita.
Reconciliação elimina tarefas "fantasma".

---

## 5. Ordem de Processamento

1. Atualizar dim_users
2. Atualizar dim_boards
3. Atualizar dim_tasks
4. Inserir f_task_events
5. Atualizar task_current_state

---

## 6. Rebuild Completo

1. Truncar analytics
2. Reprocessar staging → analytics
3. Recriar snapshot