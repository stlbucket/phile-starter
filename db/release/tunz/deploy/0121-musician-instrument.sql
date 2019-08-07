-- Deploy tunz:structure/musician_instrument to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.musician_instrument (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    musician_id bigint NOT NULL,
    note text,
    instrument_id bigint NOT NULL,
    CONSTRAINT pk_musician_instrument PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.musician_instrument ADD CONSTRAINT fk_musician_instrument_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );
  --||--
  ALTER TABLE tunz.musician_instrument ADD CONSTRAINT fk_musician_instrument_musician FOREIGN KEY ( musician_id ) REFERENCES tunz.musician( id );
  --||--
  ALTER TABLE tunz.musician_instrument ADD CONSTRAINT fk_musician_instrument_instrument FOREIGN KEY ( instrument_id ) REFERENCES tunz.instrument( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_musician_instrument() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_musician_instrument
    BEFORE INSERT OR UPDATE ON tunz.musician_instrument
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_musician_instrument();
  --||--


  --||--
  GRANT select ON TABLE tunz.musician_instrument TO app_user;
  GRANT insert ON TABLE tunz.musician_instrument TO app_user;
  GRANT update ON TABLE tunz.musician_instrument TO app_user;
  GRANT delete ON TABLE tunz.musician_instrument TO app_user;
  --||--
  alter table tunz.musician_instrument enable row level security;
  --||--
  create policy select_musician_instrument on tunz.musician_instrument for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
