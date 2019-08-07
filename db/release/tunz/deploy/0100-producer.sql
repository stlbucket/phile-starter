-- Deploy tunz:structure/producer to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.producer (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    recording_session_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    note text,
    CONSTRAINT pk_producer PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.producer ADD CONSTRAINT fk_producer_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );
  --||--
  ALTER TABLE tunz.producer ADD CONSTRAINT fk_producer_contact FOREIGN KEY ( contact_id ) REFERENCES org.contact( id );
  --||--
  ALTER TABLE tunz.producer ADD CONSTRAINT fk_producer_recording_session FOREIGN KEY ( recording_session_id ) REFERENCES tunz.recording_session( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_producer() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_producer
    BEFORE INSERT OR UPDATE ON tunz.producer
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_producer();
  --||--


  --||--
  GRANT select ON TABLE tunz.producer TO app_user;
  GRANT insert ON TABLE tunz.producer TO app_user;
  GRANT update ON TABLE tunz.producer TO app_user;
  GRANT delete ON TABLE tunz.producer TO app_user;
  --||--
  alter table tunz.producer enable row level security;
  --||--
  create policy select_producer on tunz.producer for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
