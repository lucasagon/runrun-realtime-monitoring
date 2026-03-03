create table if not exists runrun_analytics.dim_tasks (
    sk_task serial primary key,
    task_id bigint unique not null,
    title text,
    board_id bigint,
    extracted_at timestamptz
);