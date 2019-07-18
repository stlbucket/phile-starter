-- Deploy stu:structure/stu to pg
-- requires: structure/schema

BEGIN;
  CREATE TABLE stu.class (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    name text,
    description text,
    CONSTRAINT pk_class PRIMARY KEY (id)
  );
  --||--

  --||--
  GRANT select ON TABLE stu.class TO app_anonymous;
  GRANT insert ON TABLE stu.class TO app_anonymous;
  GRANT update ON TABLE stu.class TO app_anonymous;
  GRANT delete ON TABLE stu.class TO app_anonymous;
  --||--

COMMIT;
