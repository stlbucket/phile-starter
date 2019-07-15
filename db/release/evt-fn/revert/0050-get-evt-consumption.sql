-- Revert evt-fn:function/consume_all_events from pg

BEGIN;

drop function if exists evt_fn.get_evt_consumption(bigint);

COMMIT;
