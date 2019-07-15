-- Deploy evt-fn:function/get_evt_consumption to pg
-- requires: structure/schema

BEGIN;

  create or replace function evt_fn.get_evt_consumption(
    _evt_consumption_id bigint
  ) returns evt.evt_consumption AS $$
  DECLARE
    _evt_consumption evt.evt_consumption;
  BEGIN
    select *
    into _evt_consumption
    from evt.evt_consumption
    where id = _evt_consumption_id
    ;

    if _evt_consumption.id is null then
      raise exception 'no evt consumption for id: %', _evt_consumption_id;
    end if;

    if _evt_consumption.result != 'Captured' then
      raise exception 'evt has already been consumed by this handler id: %', _evt_consumption_id;
    end if;

    return _evt_consumption;
  END;
  $$ language plpgsql strict security definer;
  --||--
  comment on function evt_fn.get_evt_consumption(bigint) is 'get an evt_consumption';
  --||--
  GRANT execute ON FUNCTION evt_fn.get_evt_consumption(bigint) TO app_demon;

COMMIT;
