-- Revert evt-fn:function/consume_all_events from pg

BEGIN;

drop function if exists evt_fn.consume_all_events(text);

COMMIT;
