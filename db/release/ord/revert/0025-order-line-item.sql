-- Revert ord:custom-type/order_line_item from pg

BEGIN;

  DROP TABLE IF EXISTS ord.order_line_item CASCADE;

COMMIT;
