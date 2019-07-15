-- Revert evt-fn:function/get_evt from pg

BEGIN;

drop function if exists evt_fn.get_evt(bigint);

COMMIT;
