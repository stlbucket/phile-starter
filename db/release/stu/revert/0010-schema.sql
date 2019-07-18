-- Revert stu:structure/schema from pg

BEGIN;

  DROP SCHEMA stu CASCADE;

COMMIT;
