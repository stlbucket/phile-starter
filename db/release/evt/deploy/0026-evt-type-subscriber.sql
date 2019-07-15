-- Deploy evt:structure/evt_type_subscriber to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE evt.evt_type_subscriber (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator()
    ,evt_type text not null
    ,consume_handler text not null check(consume_handler != '')
    ,revert_handler text null
    ,constraint uq_evt_type_subscriber unique (evt_type, consume_handler)
    ,constraint pk_evt_type_subscriber PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE evt.evt_type_subscriber ADD CONSTRAINT fk_evt_type_subscriberevt_type FOREIGN KEY ( evt_type ) REFERENCES evt.evt_type( id );
  --||--
  grant select on evt.evt_type_subscriber to app_user;
COMMIT;
