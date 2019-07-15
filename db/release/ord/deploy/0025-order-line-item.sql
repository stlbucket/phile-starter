-- Deploy ord:order_line_item to pg
-- requires: sschema

BEGIN;

  CREATE TABLE ord.order_line_item (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator()
    ,jsd_license_id bigint NOT NULL
    ,order_info_id bigint NOT NULL
    ,inventory_lot_id bigint NOT NULL
    ,description text
    ,external_id text
    ,total_price numeric(10,2)
    ,CONSTRAINT pk_order_line_item PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE ord.order_line_item ADD CONSTRAINT fk_order_line_item_jsd_license FOREIGN KEY ( jsd_license_id ) REFERENCES giant.jsd_license( id );
  --||--
  ALTER TABLE ord.order_line_item ADD CONSTRAINT fk_order_line_item_order_info FOREIGN KEY ( order_info_id ) REFERENCES ord.order_info( id );
  --||--
  ALTER TABLE ord.order_line_item ADD CONSTRAINT fk_order_line_item_inventory_lot FOREIGN KEY ( inventory_lot_id ) REFERENCES inv.inventory_lot( id );
  --||--
  grant select on ord.order_line_item to app_user;

COMMIT;
