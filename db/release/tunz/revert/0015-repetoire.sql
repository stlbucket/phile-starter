-- Revert tunz:structure/repetoire from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_repetoire ON tunz.repetoire;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_repetoire();

  DROP TABLE IF EXISTS tunz.repetoire CASCADE;

COMMIT;
