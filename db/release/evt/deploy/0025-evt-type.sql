-- Deploy evt:structure/evt_type to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE evt.evt_type (
    id text NOT NULL unique check (id != '')
    ,external_event_type text
    ,ordering_field text not null
    ,CONSTRAINT pk_evt_type PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE evt.evt_type ADD CONSTRAINT fk_evt_type_order_field FOREIGN KEY ( ordering_field ) REFERENCES evt.evt_ordering_field( id );
  --||--
  grant select on evt.evt_type to app_user;
COMMIT;
