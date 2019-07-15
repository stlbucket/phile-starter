-- Deploy util_fn:structure/schema to pg
-- requires: app-roles:roles

BEGIN;

  CREATE SCHEMA util_fn;

  GRANT USAGE ON SCHEMA util_fn TO app_demon;

COMMIT;
