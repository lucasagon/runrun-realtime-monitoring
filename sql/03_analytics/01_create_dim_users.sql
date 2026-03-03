create schema if not exists runrun_analytics;

create table if not exists runrun_analytics.dim_users (
    user_id text primary key,
    name text,
    email text,
    position text,
    is_manager boolean,
    on_vacation boolean,
    extracted_at timestamptz
);