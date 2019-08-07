-- Revert tunz:structure/musician_track from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_musician_track ON tunz.musician_track;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_musician_track();

  DROP TABLE IF EXISTS tunz.musician_track CASCADE;

COMMIT;
