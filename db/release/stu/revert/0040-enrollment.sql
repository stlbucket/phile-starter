-- Revert stu:0040-enrollment from pg

BEGIN;

  DROP TABLE IF EXISTS stu.enrollment CASCADE;

COMMIT;
