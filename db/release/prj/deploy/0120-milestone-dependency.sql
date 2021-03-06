

-- Deploy prj:structure/0120-milestone-dependency to pg
-- requires: prj:structure/0110-task-dependency
BEGIN;
CREATE TABLE IF NOT EXISTS prj.milestone_dependency (
  id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
  created_at timestamp NOT NULL DEFAULT current_timestamp,
  updated_at timestamp NOT NULL,
  parent_milestone_id bigint NOT NULL,
  child_milestone_id bigint NOT NULL,
  app_tenant_id bigint NOT NULL,
  CONSTRAINT pk_milestone_dependency PRIMARY KEY (id)
);
--||--
GRANT select ON TABLE prj.milestone_dependency TO app_user;
GRANT insert ON TABLE prj.milestone_dependency TO app_user;
GRANT update ON TABLE prj.milestone_dependency TO app_user;
GRANT delete ON TABLE prj.milestone_dependency TO app_user;
--||--
alter table prj.milestone_dependency enable row level security;
--||--
create policy select_milestone_dependency on prj.milestone_dependency for select
  using (app_tenant_id = auth_fn.current_app_tenant_id());
--||--
comment on table prj.milestone_dependency is E'@omit create,update,delete';

--||--
CREATE FUNCTION prj.fn_timestamp_update_milestone_dependency() RETURNS trigger AS $$
BEGIN
  NEW.updated_at = current_timestamp;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;
--||--
CREATE TRIGGER tg_timestamp_update_milestone_dependency
  BEFORE INSERT OR UPDATE ON prj.milestone_dependency
  FOR EACH ROW
  EXECUTE PROCEDURE prj.fn_timestamp_update_milestone_dependency();
--||--

COMMIT;
