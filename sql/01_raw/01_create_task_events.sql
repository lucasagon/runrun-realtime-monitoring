create schema if not exists runrun_raw;

create table if not exists runrun_raw.task_events (
    id serial primary key,
    event text not null,
    event_type text not null,
    task_id bigint not null,
    payload jsonb not null,
    happened_at timestamptz not null,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

create index if not exists idx_raw_task_events_task_id
    on runrun_raw.task_events (task_id);

create index if not exists idx_raw_task_events_happened_at
    on runrun_raw.task_events (happened_at);