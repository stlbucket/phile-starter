-- Deploy evt:structure/evt_consumption to pg
-- requires: structure/schema

BEGIN;

  DROP TABLE IF EXISTS evt.evt_consumption CASCADE;

COMMIT;
