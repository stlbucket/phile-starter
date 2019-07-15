-- Revert ord:structure/schema from pg

BEGIN;

  DROP SCHEMA if exists ord CASCADE;

COMMIT;
