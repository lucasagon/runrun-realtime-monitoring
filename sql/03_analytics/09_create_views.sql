create or replace view runrun_analytics.vw_users_current_activity as
select
    u.user_id,
    u.name as user_name,
    u.email,
    u.position,
    t.task_id,
    t.title as task_title,
    t.board_name,
    t.happened_at as started_at,
    now() - t.happened_at as tempo_ativo_interval
from runrun_analytics.task_current_state t
join runrun_analytics.dim_users u
    on u.user_id = t.performer_id
where t.current_status = 'play';