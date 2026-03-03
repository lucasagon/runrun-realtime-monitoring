insert into runrun_analytics.task_current_state (
    task_id, performer_id, current_status,
    happened_at, updated_at, title, board_name
)
select
    t.task_id,
    t.performer_id,
    t.event_type,
    t.happened_at,
    now(),
    t.title,
    dt.title
from (
    select *,
           row_number() over (
               partition by task_id
               order by happened_at desc, raw_id desc
           ) rn
    from runrun_staging.task_events
) t
join runrun_analytics.dim_tasks dt
    on dt.task_id = t.task_id
where rn = 1
on conflict (task_id) do update
set
    performer_id = excluded.performer_id,
    current_status = excluded.current_status,
    happened_at = excluded.happened_at,
    updated_at = now(),
    title = excluded.title,
    board_name = excluded.board_name;