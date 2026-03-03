create schema if not exists runrun_staging;

create table if not exists runrun_staging.task_events (
    raw_id bigint primary key,
    task_id bigint not null,
    user_id text,
    user_email text,
    performer_id text,
    performer_email text,
    event_type text not null,
    happened_at timestamptz not null,
    board_id bigint,
    title text,
    time_worked bigint,
    custom_label text,
    created_at timestamptz not null
);