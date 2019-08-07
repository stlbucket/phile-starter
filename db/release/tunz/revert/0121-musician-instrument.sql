-- Revert tunz:structure/musician_instrument from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_musician_instrument ON tunz.musician_instrument;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_musician_instrument();

  DROP TABLE IF EXISTS tunz.musician_instrument CASCADE;

COMMIT;
