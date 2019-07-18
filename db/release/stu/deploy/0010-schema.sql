-- Deploy stu:structure/schema to pg
-- requires: app-roles:roles

BEGIN;

  CREATE SCHEMA stu;

  GRANT USAGE ON SCHEMA stu TO app_anonymous;

COMMIT;
