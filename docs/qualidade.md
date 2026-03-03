# Monitoramento e Qualidade

## 1. Pauses Forçados Duplicados

Query de validação:

- Conta pauses com payload.forced = true
- Verifica intervalo entre eventos
- Identifica possíveis falhas no guard

---

## 2. Tarefas Fantasma

Validação entre:

- Snapshot (task_current_state)
- API /tasks?is_working_on=true

Detecta divergências onde:

- Snapshot indica play
- API indica não ativo

---

## 3. Integridade Referencial

Valida:

- f_task_events sempre referenciando sk_task válido
- f_task_events sempre referenciando sk_board válido

---

## 4. Estratégia de Confiabilidade

- Raw preserva histórico
- Rebuild determinístico possível
- Reconciliação periódica
- Idempotência nas inserções