-- Deploy evt-fn:function/consume_all_events to pg
-- requires: structure/schema

BEGIN;

  CREATE function evt_fn.consume_all_events(
    _evt_type_id text
  ) returns setof evt.evt AS $$
  DECLARE
    _sql text;
    _evt evt.evt;
    _evt_type evt.evt_type;
    _consumed_event evt.evt;
  BEGIN
    SELECT *
    INTO _evt_type
    FROM evt.evt_type
    WHERE id = _evt_type_id;

    IF _evt_type.id IS NULL THEN
      RAISE EXCEPTION 'No event type for id: %', _evt_type_id;
    END IF;

    -- _sql := 

    FOR _evt IN
      SELECT *
      FROM evt.evt
      WHERE evt_type_id = _evt_type_id
      AND result = 'Consumed'
      ORDER BY captured_at
    LOOP
      _consumed_event := (select evt_fn.consume_event(_evt.id));
      RETURN NEXT _consumed_event;
    END LOOP;

    RETURN;
  END;
  $$ language plpgsql strict security definer;
  --||--
  comment on function evt_fn.consume_all_events(text) is 'Consume all events of a given type with proper ordering.';
  --||--
  -- GRANT execute ON FUNCTION evt_fn.consume_all_events(text) TO app_user;

COMMIT;
