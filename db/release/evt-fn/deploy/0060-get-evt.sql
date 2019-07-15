-- Deploy evt-fn:function/get_evt to pg
-- requires: structure/schema

BEGIN;

  create or replace function evt_fn.get_evt(
    _evt_id bigint
  ) returns evt.evt AS $$
  DECLARE
    _evt evt.evt;
  BEGIN
    select *
    into _evt
    from evt.evt
    where id = _evt_id
    ;

    if _evt.id is null then
      raise exception 'no evt for id: %', _evt;
    end if;

    return _evt;
  END;
  $$ language plpgsql strict security definer;
  --||--
  comment on function evt_fn.get_evt(bigint) is 'get an evt';
  --||--
  GRANT execute ON FUNCTION evt_fn.get_evt(bigint) TO app_demon;

COMMIT;
