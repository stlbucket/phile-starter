-- Revert util_fn:structure/schema from pg

BEGIN;

  DROP SCHEMA util_fn CASCADE;

COMMIT;
