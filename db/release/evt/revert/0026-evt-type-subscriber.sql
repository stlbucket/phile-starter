-- Deploy evt:structure/evt_type_subscriber to pg
-- requires: structure/schema

BEGIN;

  DROP TABLE IF EXISTS evt.evt_type_subscriber CASCADE;

COMMIT;
