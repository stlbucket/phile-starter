-- Deploy stu:0030-student to pg
-- requires: 0010-schema

BEGIN;
  CREATE TABLE stu.student (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    name text,
    dob date,
    CONSTRAINT pk_student PRIMARY KEY (id)
  );

  --||--
  GRANT select ON TABLE stu.student TO app_anonymous;
  GRANT insert ON TABLE stu.student TO app_anonymous;
  GRANT update ON TABLE stu.student TO app_anonymous;
  GRANT delete ON TABLE stu.student TO app_anonymous;
  --||--

COMMIT;
