insert into runrun_analytics.f_task_events (
    raw_id, sk_task, sk_board, performer_id,
    event_type, happened_at, event_date, created_at
)
select
    t.raw_id,
    dt.sk_task,
    db.sk_board,
    t.performer_id,
    t.event_type,
    t.happened_at,
    t.happened_at::date,
    t.created_at
from runrun_staging.task_events t
join runrun_analytics.dim_tasks dt
    on dt.task_id = t.task_id
left join runrun_analytics.dim_boards db
    on db.board_id = dt.board_id
on conflict (raw_id) do nothing;