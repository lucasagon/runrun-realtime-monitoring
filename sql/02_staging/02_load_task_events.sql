insert into runrun_staging.task_events (
    raw_id, task_id, user_id, user_email, performer_id, performer_email,
    event_type, happened_at, board_id, title, time_worked, custom_label, created_at
)
select
    r.id,
    r.task_id,
    r.payload #>> '{data,task,user,id}',
    r.payload #>> '{data,task,user,email}',
    r.payload #>> '{performer,id}',
    r.payload #>> '{performer,email}',
    r.event_type,
    (r.payload #>> '{happened_at}')::timestamptz,
    (r.payload #>> '{data,task,board,id}')::bigint,
    r.payload #>> '{data,task,title}',
    (r.payload #>> '{data,task,time_worked}')::bigint,
    r.payload #>> '{data,task,custom_fields,custom_193,label}',
    r.created_at
from runrun_raw.task_events r
left join runrun_staging.task_events s
    on s.raw_id = r.id
where s.raw_id is null;