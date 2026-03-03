create table if not exists runrun_analytics.f_task_events (
    sk_event serial primary key,
    raw_id bigint unique not null,
    sk_task bigint not null,
    sk_board bigint,
    performer_id text,
    event_type text not null,
    happened_at timestamptz not null,
    event_date date not null,
    created_at timestamptz not null
);

create index if not exists idx_f_task_events_task
    on runrun_analytics.f_task_events (sk_task);

create index if not exists idx_f_task_events_date
    on runrun_analytics.f_task_events (event_date);