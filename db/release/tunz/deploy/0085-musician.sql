-- Deploy tunz:structure/musician to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.musician (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    band_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    note text,
    repetoire_id bigint NULL UNIQUE,
    CONSTRAINT pk_musician PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.musician ADD CONSTRAINT fk_musician_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );
  --||--
  ALTER TABLE tunz.musician ADD CONSTRAINT fk_musician_contact FOREIGN KEY ( contact_id ) REFERENCES org.contact( id );
  --||--
  ALTER TABLE tunz.musician ADD CONSTRAINT fk_musician_band FOREIGN KEY ( band_id ) REFERENCES tunz.band( id );
  --||--
  ALTER TABLE tunz.band ADD CONSTRAINT fk_musician_repetoire FOREIGN KEY ( repetoire_id ) REFERENCES tunz.repetoire( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_musician() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_musician
    BEFORE INSERT OR UPDATE ON tunz.musician
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_musician();
  --||--


  --||--
  GRANT select ON TABLE tunz.musician TO app_user;
  GRANT insert ON TABLE tunz.musician TO app_user;
  GRANT update ON TABLE tunz.musician TO app_user;
  GRANT delete ON TABLE tunz.musician TO app_user;
  --||--
  alter table tunz.musician enable row level security;
  --||--
  create policy select_musician on tunz.musician for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
