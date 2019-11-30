-- Revert tunz:structure/studio from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_studio ON tunz.studio;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_studio();

  DROP TABLE IF EXISTS tunz.studio CASCADE;

COMMIT;
