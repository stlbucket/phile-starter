
-- Deploy auth:0060-app-user to pg
-- requires: 0050-app-tenant

BEGIN;

  CREATE TABLE auth.app_user (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    username text UNIQUE NOT NULL,
    recovery_email text UNIQUE NOT NULL,
    password_hash text NOT NULL,
    inactive boolean NOT NULL DEFAULT false,
    password_reset_required boolean NOT NULL DEFAULT false,
    permission_key auth.permission_key NOT NULL,
    CONSTRAINT pk_app_user PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE auth.app_user ADD CONSTRAINT fk_app_user_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );

  --||--
  GRANT select ON TABLE auth.app_user TO app_user;
  -- GRANT insert ON TABLE auth.app_user TO app_admin;
  -- GRANT update ON TABLE auth.app_user TO app_admin;
  -- GRANT delete ON TABLE auth.app_user TO app_admin;

  -- alter table auth.app_user enable row level security;
  -- --||--
  -- create policy select_app_user_app_user on auth.app_user for select to app_user
  --   using (id = current_setting('jwt.claims.app_user_id')::bigint);
  -- create policy select_app_user_app_admin on auth.app_user for select to app_admin
  --   using (app_tenant_id = current_setting('jwt.claims.app_tenant_id')::bigint);
  -- create policy select_app_user_app_super_admin on auth.app_user for select to app_super_admin
  --   using (true);

  --||--
  CREATE FUNCTION auth.fn_timestamp_update_app_user() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_app_user
    BEFORE INSERT OR UPDATE ON auth.app_user
    FOR EACH ROW
    EXECUTE PROCEDURE auth.fn_timestamp_update_app_user();
  --||--

  comment on table auth.app_user is E'@omit create,update,delete';

  comment on column auth.app_user.id is
  E'@omit create';
  comment on column auth.app_user.created_at is
  E'@omit create,update';
  comment on column auth.app_user.updated_at is
  E'@omit create,update';
  comment on column auth.app_user.password_hash is
  E'@omit';

COMMIT;
