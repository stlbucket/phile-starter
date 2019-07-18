-- Verify stu:structure/schema on pg

BEGIN;

  SELECT pg_catalog.has_schema_privilege('stu', 'usage');

ROLLBACK;
