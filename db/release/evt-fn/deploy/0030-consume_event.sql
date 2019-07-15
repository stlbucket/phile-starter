-- Deploy evt-fn:function/consume_event to pg
-- requires: structure/schema

BEGIN;

  create or replace function evt_fn.consume_event(
    _evt_id bigint
  ) returns evt.evt AS $$
  DECLARE
    _app_user auth.app_user;
    _evt evt.evt;
    _evt_type evt.evt_type;
    _result jsonb;
    _sql text;
  BEGIN
    SELECT *
    INTO _evt
    FROM evt.evt
    WHERE id = _evt_id;

    IF _evt.id IS NULL THEN
      RAISE EXCEPTION 'No event for id: %', _evt_id;
    END IF;

    IF _evt.result = 'Captured' THEN
      select *
      into _evt_type
      from evt.evt_type
      where id = _evt.evt_type
      ;

      _sql := 'select ' || _evt_type.consume_handler || '(' || _evt_id || ');';

      -- EXECUTE _sql INTO _evt;
      -- raise exception '_evt: %', _evt;
      EXECUTE _sql;

      select * into _evt from evt.evt where id = _evt_id;
    END IF;

    RETURN _evt;
  END;
  $$ language plpgsql strict security definer;
  --||--
  comment on function evt_fn.consume_event(bigint) is 'Consume an event.';
  --||--
  GRANT execute ON FUNCTION evt_fn.consume_event(bigint) TO app_demon;

COMMIT;
