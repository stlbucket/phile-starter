-- Deploy tunz:structure/studio_session to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.studio_session (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    session_start timestamp NULL,
    session_end timestamp NULL,
    name text,
    studio_id bigint NULL,
    CONSTRAINT pk_studio_session PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.studio_session ADD CONSTRAINT fk_studio_session_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );
  --||--
  ALTER TABLE tunz.studio_session ADD CONSTRAINT fk_studio_session_studio FOREIGN KEY ( studio_id ) REFERENCES tunz.studio( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_studio_session() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_studio_session
    BEFORE INSERT OR UPDATE ON tunz.studio_session
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_studio_session();
  --||--


  --||--
  GRANT select ON TABLE tunz.studio_session TO app_user;
  GRANT insert ON TABLE tunz.studio_session TO app_user;
  GRANT update ON TABLE tunz.studio_session TO app_user;
  GRANT delete ON TABLE tunz.studio_session TO app_user;
  --||--
  alter table tunz.studio_session enable row level security;
  --||--
  create policy select_studio_session on tunz.studio_session for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
