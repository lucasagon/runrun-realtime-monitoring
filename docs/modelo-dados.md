# Modelo de Dados

## 1. Camada Raw

### Tabela: task_events

Grão: 1 linha por evento recebido.

Principais campos:

- id (PK)
- event
- event_type
- task_id
- payload (jsonb)
- happened_at
- created_at

Características:

- Append-only
- Sem deduplicação
- Payload completo preservado

---

## 2. Camada Staging

### Tabela: task_events

Grão: 1 linha por evento normalizado.

Principais campos:

- raw_id
- task_id
- user_id
- performer_id
- event_type
- happened_at
- board_id
- title

Responsável por:

- Extração do JSON
- Tipagem
- Deduplicação baseada em raw_id

---

## 3. Camada Analytics

### Dimensão: dim_users

Natural key: user_id  
Contém atributos descritivos.

---

### Dimensão: dim_boards

Natural key: board_id  
Possui surrogate key sk_board.

---

### Dimensão: dim_tasks

Natural key: task_id  
Possui surrogate key sk_task.

---

### Fato: f_task_events

Grão: 1 linha por evento.

Campos principais:

- sk_event
- raw_id
- sk_task
- sk_board
- performer_id
- event_type
- happened_at
- event_date

Permite análise histórica de:

- Produtividade
- Volume de eventos
- Distribuição por usuário
- Distribuição por board

---

## 4. Snapshot Operacional

### Tabela: task_current_state

Grão: 1 linha por tarefa.

Campos principais:

- task_id (PK)
- performer_id
- current_status
- happened_at
- updated_at
- title
- board_name

Representa o estado mais recente da tarefa.

Separada da fato para:

- Evitar agregações complexas
- Permitir consulta rápida de estado atual