-- Verify ord:structure/schema on pg

BEGIN;

  SELECT pg_catalog.has_schema_privilege('ord', 'usage');

ROLLBACK;
