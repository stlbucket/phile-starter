-- Deploy org:structure/contact to pg
-- requires: structure/organization

BEGIN;

  CREATE TABLE org.contact (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    organization_id bigint NULL,
    location_id bigint NULL,
    external_id text,
    first_name text,
    last_name text,
    email text,
    cell_phone text,
    office_phone text,
    title text,
    nickname text,
    CONSTRAINT uq_contact_app_tenant_and_email UNIQUE (app_tenant_id, email),
    CONSTRAINT uq_contact_app_tenant_and_external_id UNIQUE (app_tenant_id, external_id),
    CONSTRAINT pk_contact PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE org.contact ADD CONSTRAINT fk_contact_organization FOREIGN KEY ( organization_id ) REFERENCES org.organization( id );
  --||--
  ALTER TABLE org.contact ADD CONSTRAINT fk_contact_location FOREIGN KEY ( location_id ) REFERENCES org.location( id );
  --||--
  ALTER TABLE org.contact ADD CONSTRAINT fk_contact_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );

  --||--
  CREATE FUNCTION org.fn_timestamp_update_contact() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    if NEW.app_tenant_id is null then 
      -- only users with 'SuperAdmin' permission_key will be able to arbitrarily set this value
      -- rls policy (below) will prevent users from specifying an alternate app_tenant_id
      NEW.app_tenant_id := auth_fn.current_app_tenant_id();
    end if;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_contact
    BEFORE INSERT OR UPDATE ON org.contact
    FOR EACH ROW
    EXECUTE PROCEDURE org.fn_timestamp_update_contact();
  --||--


  --||--
  GRANT select ON TABLE org.contact TO app_user;
  GRANT insert ON TABLE org.contact TO app_user;
  GRANT update ON TABLE org.contact TO app_user;
  GRANT delete ON TABLE org.contact TO app_user;
  --||--
  alter table org.contact enable row level security;
  --||--
  create policy all_contact on org.contact for all to app_user  -- sql action could change according to your needs
  using (app_tenant_id = auth_fn.current_app_tenant_id());  -- this function could be replaced entirely or on individual policies as needed

  create policy super_aadmin_contact on org.contact for all to app_super_admin
  using (1 = 1);

  comment on column org.contact.app_tenant_id is
  E'@omit create, update'; -- id is always set by the db.  this might change in an event-sourcing scenario
  comment on column org.contact.id is
  E'@omit create';
  comment on column org.contact.created_at is
  E'@omit create,update';
  comment on column org.contact.updated_at is
  E'@omit create,update';
  comment on column org.contact.organization_id is
  E'@omit create,update';

COMMIT;
