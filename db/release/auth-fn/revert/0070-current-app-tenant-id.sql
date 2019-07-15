-- Revert auth-fn:current_app_tenant_id from pg

BEGIN;

  DROP FUNCTION IF EXISTS auth_fn.current_app_tenant_id() cascade;

COMMIT;
