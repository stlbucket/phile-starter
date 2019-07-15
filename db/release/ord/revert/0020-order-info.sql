-- Revert ord:order_info from pg

BEGIN;

  DROP TABLE IF EXISTS ord.order_info CASCADE;

COMMIT;
