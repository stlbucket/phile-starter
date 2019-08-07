-- Deploy stu:0200-stu-functions to pg
-- requires: 0010-schema

BEGIN;
  create or replace function stu.create_class(
    _name text,
    _description text
  ) returns stu.class AS $$
  DECLARE
    _class stu.class;
  BEGIN 
    select *
    into _class
    from stu.class c
    where c.name = _name
    ;

    if _class.id is null then
      insert into stu.class(
        name,
        description
      )
      values (
        _name,
        _description
      )
      returning *
      into _class
      ;
    end if;

    return _class;
  END;
  $$ language plpgsql strict security definer;
  --||--
  GRANT execute ON FUNCTION stu.create_class(text,text) TO public;

  create or replace function stu.update_class(
    _id bigint,
    _name text,
    _description text
  ) returns stu.class AS $$
  DECLARE
    _class stu.class;
  BEGIN
    select *
    into _class
    from stu.class c
    where c.id = _id
    ;

    if _class.id is null then
      raise exception 'no class exists for id: %', _id;
    end if;

    update stu.class
    set
      name = _name,
      description = _description
    where id = _id
    returning *
    into _class
    ;

    return _class;
  END;
  $$ language plpgsql strict security definer;
  --||--
  GRANT execute ON FUNCTION stu.update_class(bigint,text,text) TO public;

  create or replace function stu.delete_class(
    _id bigint
  ) returns bigint AS $$
  DECLARE
    _class stu.class;
  BEGIN

    select *
    into _class
    from stu.class c
    where c.id = _id
    ;

    if _class.id is null then
      raise exception 'no class exists for id: %', _id;
    end if;

    delete from stu.enrollment where class_id = _id;
    delete from stu.class where id = _id;

    return 1;
  END;
  $$ language plpgsql strict security definer;
  --||--
  GRANT execute ON FUNCTION stu.delete_class(bigint) TO public;







--  students
  create or replace function stu.create_student(
    _name text,
    _dob date,
    _class_ids bigint[]
  ) returns stu.student AS $$
  DECLARE
    _student stu.student;
    _class_id bigint;
  BEGIN
    select *
    into _student
    from stu.student c
    where c.name = _name
    ;

    if _student.id is null then
      insert into stu.student(
        name,
        dob
      )
      values (
        _name,
        _dob
      )
      returning *
      into _student
      ;
    end if;

    foreach _class_id in array _class_ids
    loop
      insert into stu.enrollment(student_id, class_id)
      values (_student.id, _class_id)
      on conflict
      do nothing;
    end loop;

    return _student;
  END;
  $$ language plpgsql strict security definer;
  --||--
  GRANT execute ON FUNCTION stu.create_student(text,date,bigint[]) TO public;

  create or replace function stu.update_student(
    _id bigint,
    _name text,
    _dob date,
    _class_ids bigint[]
  ) returns stu.student AS $$
  DECLARE
    _student stu.student;
    _class_id bigint;
  BEGIN

    select *
    into _student
    from stu.student c
    where c.id = _id
    ;

    if _student.id is null then
      raise exception 'no student exists for id: %', _id;
    end if;

    update stu.student
    set
      name = _name,
      dob = _dob
    where id = _id
    returning *
    into _student
    ;

    foreach _class_id in array _class_ids
    loop
      insert into stu.enrollment(student_id, class_id)
      values (_student.id, _class_id)
      on conflict
      do nothing;
    end loop;

    return _student;
  END;
  $$ language plpgsql strict security definer;
  --||--
  GRANT execute ON FUNCTION stu.update_student(bigint,text,date,bigint[]) TO public;

  create or replace function stu.delete_student(
    _id bigint
  ) returns integer AS $$
  DECLARE
    _student stu.student;
  BEGIN
    select *
    into _student
    from stu.student c
    where c.id = _id
    ;

    if _student.id is null then
      raise exception 'no student exists for id: %', _id;
    end if;

    delete from stu.enrollment where student_id = _id;
    delete from stu.student where id = _id;

    return 1;
  END;
  $$ language plpgsql strict security definer;
  --||--
  GRANT execute ON FUNCTION stu.delete_student(bigint) TO public;


  create or replace function stu.create_demo_data() returns setof stu.student AS $$
  DECLARE
    _student stu.student;
  BEGIN
    perform stu.create_class('Physics', 'Intro to Physics');
    perform stu.create_class('Geometry', 'Intro to Geometry');
    perform stu.create_class('Music', 'Intro to Music');
    perform stu.create_class('Gardening', 'Intro to Gardening');
    perform stu.create_class('Cooking', 'Intro to Cooking');

    perform stu.create_student('Tony', '4/14/1955', '{}');
    perform stu.create_student('Paulie', '9/15/1953', '{}');
    perform stu.create_student('Johnny', '2/2/1954', '{}');


    for _student in
      select * from stu.student
    loop
      insert into stu.enrollment(student_id, class_id)
      select
        _student.id,
        (SELECT id FROM stu.class OFFSET floor(random()*N) LIMIT 1)
      on conflict do nothing
      ;

      insert into stu.enrollment(student_id, class_id)
      select
        _student.id,
        (SELECT id FROM stu.class OFFSET floor(random()*N) LIMIT 1)
      on conflict do nothing
      ;

      insert into stu.enrollment(student_id, class_id)
      select
        _student.id,
        (SELECT id FROM stu.class OFFSET floor(random()*N) LIMIT 1)
      on conflict do nothing
      ;
    end loop;

    return query select * from stu.student;
  END;    
  $$ language plpgsql strict security definer;
  --||--
  GRANT execute ON FUNCTION stu.create_demo_data() TO public;
COMMIT;
