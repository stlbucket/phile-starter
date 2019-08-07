-- Deploy tunz:structure/repetoire to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.repetoire (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    external_id text,
    CONSTRAINT pk_repetoire PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.repetoire ADD CONSTRAINT fk_repetoire_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_repetoire() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_repetoire
    BEFORE INSERT OR UPDATE ON tunz.repetoire
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_repetoire();
  --||--


  --||--
  GRANT select ON TABLE tunz.repetoire TO app_user;
  GRANT insert ON TABLE tunz.repetoire TO app_user;
  GRANT update ON TABLE tunz.repetoire TO app_user;
  GRANT delete ON TABLE tunz.repetoire TO app_user;
  --||--
  alter table tunz.repetoire enable row level security;
  --||--
  create policy select_repetoire on tunz.repetoire for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
