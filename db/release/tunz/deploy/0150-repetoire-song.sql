-- Deploy tunz:structure/repetoire_song to pg
-- requires: structure/schema

BEGIN;

  CREATE TABLE tunz.repetoire_song (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    app_tenant_id bigint NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp,
    updated_at timestamp NOT NULL,
    repetoire_id bigint NOT NULL,
    song_id bigint NOT NULL,
    note text,
    CONSTRAINT pk_repetoire_song PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE tunz.repetoire_song ADD CONSTRAINT fk_repetoire_song_app_tenant FOREIGN KEY ( app_tenant_id ) REFERENCES auth.app_tenant( id );
  --||--
  ALTER TABLE tunz.repetoire_song ADD CONSTRAINT fk_repetoire_song_repetoire FOREIGN KEY ( repetoire_id ) REFERENCES tunz.repetoire( id );
  --||--
  ALTER TABLE tunz.repetoire_song ADD CONSTRAINT fk_repetoire_song_song FOREIGN KEY ( song_id ) REFERENCES tunz.song( id );

  --||--
  CREATE FUNCTION tunz.fn_timestamp_update_repetoire_song() RETURNS trigger AS $$
  BEGIN
    NEW.updated_at = current_timestamp;
    RETURN NEW;
  END; $$ LANGUAGE plpgsql;
  --||--
  CREATE TRIGGER tg_timestamp_update_repetoire_song
    BEFORE INSERT OR UPDATE ON tunz.repetoire_song
    FOR EACH ROW
    EXECUTE PROCEDURE tunz.fn_timestamp_update_repetoire_song();
  --||--


  --||--
  GRANT select ON TABLE tunz.repetoire_song TO app_user;
  GRANT insert ON TABLE tunz.repetoire_song TO app_user;
  GRANT update ON TABLE tunz.repetoire_song TO app_user;
  GRANT delete ON TABLE tunz.repetoire_song TO app_user;
  --||--
  alter table tunz.repetoire_song enable row level security;
  --||--
  create policy select_repetoire_song on tunz.repetoire_song for select
    using (app_tenant_id = auth_fn.current_app_tenant_id());

COMMIT;
