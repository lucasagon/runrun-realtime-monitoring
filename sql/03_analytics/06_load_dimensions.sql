-- dim_tasks
insert into runrun_analytics.dim_tasks (task_id, title, board_id, extracted_at)
select
    task_id,
    title,
    board_id,
    max(created_at)
from runrun_staging.task_events
group by task_id, title, board_id
on conflict (task_id) do update
set
    title = excluded.title,
    board_id = excluded.board_id,
    extracted_at = excluded.extracted_at;

-- dim_boards
insert into runrun_analytics.dim_boards (board_id, board_name, extracted_at)
select
    board_id,
    max(title),
    max(created_at)
from runrun_staging.task_events
group by board_id
on conflict (board_id) do nothing;