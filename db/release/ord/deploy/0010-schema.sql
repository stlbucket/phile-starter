-- Deploy ord:structure/schema to pg
-- requires: app-roles:roles

BEGIN;

  CREATE SCHEMA ord;

  GRANT USAGE ON SCHEMA ord TO app_user, app_demon;

COMMIT;
