-- Verify util_fn:structure/schema on pg

BEGIN;

  SELECT pg_catalog.has_schema_privilege('util_fn', 'usage');

ROLLBACK;
