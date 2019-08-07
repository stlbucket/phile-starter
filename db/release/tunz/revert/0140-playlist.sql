-- Revert tunz:structure/playlist from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_playlist ON tunz.playlist;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_playlist();

  DROP TABLE IF EXISTS tunz.playlist CASCADE;

COMMIT;
