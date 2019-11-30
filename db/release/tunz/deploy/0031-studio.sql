-- Deploy tunz:structure/studio to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.studio (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    external_id text,
    organization_id bigint NULL,
    location_id bigint NULL,
    facility_id bigint NULL,
    CONSTRAINT pk_studio PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.studio ADD CONSTRAINT fk_studio_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );
  --||--
  ALTER TABLE tunz.studio ADD CONSTRAINT fk_studio_organization FOREIGN KEY ( organization_id ) REFERENCES org.organization( id );
  --||--
  ALTER TABLE tunz.studio ADD CONSTRAINT fk_studio_location FOREIGN KEY ( location_id ) REFERENCES org.location( id );
  --||--
  ALTER TABLE tunz.studio ADD CONSTRAINT fk_studio_facility FOREIGN KEY ( facility_id ) REFERENCES org.facility( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_studio() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_studio
    BEFORE INSERT OR UPDATE ON tunz.studio
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_studio();
  --||--


  --||--
  GRANT select ON TABLE tunz.studio TO app_user;
  GRANT insert ON TABLE tunz.studio TO app_user;
  GRANT update ON TABLE tunz.studio TO app_user;
  GRANT delete ON TABLE tunz.studio TO app_user;
  --||--
  alter table tunz.studio enable row level security;
  --||--
  create policy select_studio on tunz.studio for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
