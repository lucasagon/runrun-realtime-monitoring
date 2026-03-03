truncate runrun_analytics.f_task_events cascade;
truncate runrun_analytics.task_current_state cascade;
truncate runrun_analytics.dim_tasks cascade;
truncate runrun_analytics.dim_boards cascade;
truncate runrun_analytics.dim_users cascade;

-- Reprocessar:
-- 1. load_dimensions.sql
-- 2. load_f_task_events.sql
-- 3. update_snapshot.sql