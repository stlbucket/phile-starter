-- Deploy stu:structure/stu to pg
-- requires: structure/schema

BEGIN;

  DROP TABLE IF EXISTS stu.class CASCADE;

COMMIT;
  