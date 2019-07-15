-- Revert auth-fn:current_app_user_id from pg

BEGIN;

  DROP FUNCTION IF EXISTS auth_fn.current_app_user_id() cascade;

COMMIT;
