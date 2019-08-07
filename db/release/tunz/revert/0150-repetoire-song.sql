-- Revert tunz:structure/repetoire_song from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_repetoire_song ON tunz.repetoire_song;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_repetoire_song();

  DROP TABLE IF EXISTS tunz.repetoire_song CASCADE;

COMMIT;
