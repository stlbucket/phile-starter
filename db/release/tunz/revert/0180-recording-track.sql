-- Revert tunz:structure/recording_track from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_recording_track ON tunz.recording_track;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_recording_track();

  DROP TABLE IF EXISTS tunz.recording_track CASCADE;

COMMIT;
