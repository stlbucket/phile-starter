-- Deploy evt:structure/evt_consumption to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE evt.evt_consumption (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator()
    ,evt_id bigint not null
    ,evt_type_subscriber_id bigint not null
    ,outcomes jsonb NULL
    ,result text not null
    ,CONSTRAINT pk_evt_consumption PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE evt.evt_consumption ADD CONSTRAINT fk_evt_consumption_evt FOREIGN KEY ( evt_id ) REFERENCES evt.evt( id );
  --||--
  ALTER TABLE evt.evt_consumption ADD CONSTRAINT fk_evt_consumption_evt_type_subscriber FOREIGN KEY ( evt_type_subscriber_id ) REFERENCES evt.evt_type_subscriber( id );
  --||--
  grant select on evt.evt_consumption to app_user;
COMMIT;
