-- Deploy tunz:structure/playlist to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.playlist (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    booking_id bigint NOT NULL,
    song_id bigint NOT NULL,
    note text,
    performance_order integer,
    CONSTRAINT pk_playlist PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.playlist ADD CONSTRAINT fk_playlist_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );
  --||--
  ALTER TABLE tunz.playlist ADD CONSTRAINT fk_playlist_song FOREIGN KEY ( song_id ) REFERENCES tunz.song( id );
  --||--
  ALTER TABLE tunz.playlist ADD CONSTRAINT fk_playlist_booking FOREIGN KEY ( booking_id ) REFERENCES tunz.booking( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_playlist() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_playlist
    BEFORE INSERT OR UPDATE ON tunz.playlist
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_playlist();
  --||--


  --||--
  GRANT select ON TABLE tunz.playlist TO app_user;
  GRANT insert ON TABLE tunz.playlist TO app_user;
  GRANT update ON TABLE tunz.playlist TO app_user;
  GRANT delete ON TABLE tunz.playlist TO app_user;
  --||--
  alter table tunz.playlist enable row level security;
  --||--
  create policy select_playlist on tunz.playlist for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
