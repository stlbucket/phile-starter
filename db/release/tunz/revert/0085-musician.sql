-- Revert tunz:structure/musician from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_musician ON tunz.musician;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_musician();

  DROP TABLE IF EXISTS tunz.musician CASCADE;

COMMIT;
