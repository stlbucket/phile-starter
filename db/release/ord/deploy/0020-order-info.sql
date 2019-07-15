-- Deploy ord:structure/inv to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE ord.order_info (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator()
    ,seller_jsd_license_id bigint not null
    ,buyer_jsd_license_id bigint not null
    ,order_number text
    ,external_id text
    ,total_price numeric(10,2)
    ,CONSTRAINT pk_order_info PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE ord.order_info ADD CONSTRAINT fk_order_info_seller_jsd_license FOREIGN KEY ( seller_jsd_license_id ) REFERENCES giant.jsd_license( id );
  --||--
  ALTER TABLE ord.order_info ADD CONSTRAINT fk_order_info_buyer_jsd_license FOREIGN KEY ( buyer_jsd_license_id ) REFERENCES giant.jsd_license( id );
  --||--
  grant select on ord.order_info to app_user;

COMMIT;
