-- Revert stu:0200-stu-functions from pg

BEGIN;

  drop function stu.create_class(text,text);
  drop function stu.update_class(bigint,text,text);
  drop function stu.delete_class(bigint);
  drop function stu.create_student(text,date,bigint[]);
  drop function stu.update_student(bigint,text,date,bigint[]);
  drop function stu.delete_student(bigint);
  drop function stu.create_demo_data();

COMMIT;
