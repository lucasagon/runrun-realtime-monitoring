# Workflows — n8n

## 1. Webhook Play

Fluxo:

1. Trigger: Webhook
2. INSERT em runrun_raw.task_events
3. Executa transformação raw → staging
4. Atualiza analytics
5. Atualiza snapshot

---

## 2. Webhook Pause

Mesma estrutura do Play.
Diferença apenas no event_type.

---

## 3. Reconciliação

Executado a cada 1 minuto.

Fluxo:

1. GET /tasks?is_working_on=true
2. Compara com snapshot
3. Insere pause forçado quando necessário
4. Reprocessa pipeline

---

## 4. Guard de Segurança

Evita pause duplicado:

- Janela de 2 minutos
- Verifica flag forced = true
- Impede inconsistência por execução concorrente