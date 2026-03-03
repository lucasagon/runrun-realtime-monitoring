create table if not exists runrun_analytics.task_current_state (
    task_id bigint primary key,
    performer_id text,
    current_status text not null,
    happened_at timestamptz not null,
    updated_at timestamptz not null,
    title text,
    board_name text
);