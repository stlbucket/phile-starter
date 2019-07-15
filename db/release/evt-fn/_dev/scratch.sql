
select * from evt.evt_processing_result;

select * from evt.evt_type;


select evt_fn.consume_event(id) from evt.evt;