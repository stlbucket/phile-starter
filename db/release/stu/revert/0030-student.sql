-- Revert stu:0030-student from pg

BEGIN;

  DROP TABLE IF EXISTS stu.student CASCADE;

COMMIT;
