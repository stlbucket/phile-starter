-- Deploy stu:0040-enrollment to pg
-- requires: 0010-schema

BEGIN;

  CREATE TABLE stu.enrollment (
    id bigint UNIQUE NOT NULL DEFAULT shard_1.id_generator(),
    class_id bigint not null,
    student_id bigint not null,
    CONSTRAINT uq_enrollment UNIQUE(class_id, student_id),
    CONSTRAINT pk_enrollment PRIMARY KEY (id)
  );
  --||--
  ALTER TABLE stu.enrollment ADD CONSTRAINT fk_enrollment_class FOREIGN KEY ( class_id ) REFERENCES stu.class( id );
  --||--
  ALTER TABLE stu.enrollment ADD CONSTRAINT fk_enrollment_student FOREIGN KEY ( student_id ) REFERENCES stu.student( id );

  --||--
  GRANT select ON TABLE stu.enrollment TO app_anonymous;
  GRANT insert ON TABLE stu.enrollment TO app_anonymous;
  GRANT update ON TABLE stu.enrollment TO app_anonymous;
  GRANT delete ON TABLE stu.enrollment TO app_anonymous;
  --||--

COMMIT;
