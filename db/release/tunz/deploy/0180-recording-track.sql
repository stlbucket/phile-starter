-- Deploy tunz:structure/recording_track to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.recording_track (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    recording_id bigint NOT NULL,
    note text,
    track_id bigint NOT NULL,
    CONSTRAINT pk_recording_track PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.recording_track ADD CONSTRAINT fk_recording_track_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );
  --||--
  ALTER TABLE tunz.recording_track ADD CONSTRAINT fk_recording_track_recording FOREIGN KEY ( recording_id ) REFERENCES tunz.recording( id );
  --||--
  ALTER TABLE tunz.recording_track ADD CONSTRAINT fk_recording_track_track FOREIGN KEY ( track_id ) REFERENCES tunz.track( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_recording_track() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_recording_track
    BEFORE INSERT OR UPDATE ON tunz.recording_track
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_recording_track();
  --||--


  --||--
  GRANT select ON TABLE tunz.recording_track TO app_user;
  GRANT insert ON TABLE tunz.recording_track TO app_user;
  GRANT update ON TABLE tunz.recording_track TO app_user;
  GRANT delete ON TABLE tunz.recording_track TO app_user;
  --||--
  alter table tunz.recording_track enable row level security;
  --||--
  create policy select_recording_track on tunz.recording_track for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
