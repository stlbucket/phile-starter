-- Revert tunz:structure/studio_session from pg

BEGIN;

  DROP TRIGGER IF EXISTS tg_timestamp_update_studio_session ON tunz.studio_session;

  DROP FUNCTION IF EXISTS tunz.fn_timestamp_update_studio_session();

  DROP TABLE IF EXISTS tunz.studio_session CASCADE;

COMMIT;
