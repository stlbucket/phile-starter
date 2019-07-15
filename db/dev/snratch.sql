-- -- select *
-- -- from evt.evt
-- -- limit 1
-- -- ;


-- select 
--   id
--   ,entity_id_external
--   ,idempotency_hash
--   ,params
-- from evt.evt 
-- where entity_id_external = 'WAWA1.MMTH'
-- ;

-- select distinct
--   et.id
--   ,(select count(*) from evt.evt where evt_type = et.id)
-- from evt.evt_type et
-- group by et.id
-- ;


-- delete from evt.evt;


-- select "Name", "OriginID", "UniqueID"
-- from giant_src."Company"
-- ;

select 
  *
from evt.evt
where evt_type = 'leaf.inventory_transfer.import'
order by external_occurred_at desc
limit 1
;

select *
from evt.evt_type_subscriber
;

select distinct
  et.id
  ,et.ordering_field
  ,ets.consume_handler
  ,ec.result
  ,e.app_tenant_id
  ,count(e.id)
from evt.evt_type et
join evt.evt_type_subscriber ets on ets.evt_type = et.id
left join evt.evt_consumption ec on ec.evt_type_subscriber_id = ets.id
left join evt.evt e on e.id = ec.evt_id
group by 
  et.id
  ,et.ordering_field
  ,ets.consume_handler
  ,ec.result
  ,e.app_tenant_id
;

-- select 
--   -- id
--   -- ,entity_id_external
--   -- ,jsonb_pretty(params)
--   count(*)
-- from evt.evt
-- where evt_type = 'leaf.inventory_transfer.import'
-- and params->>'global_to_mme_id' = 'WAWA1.MM1BZ'
-- limit 1
-- ;

-- select
--  max((params->>'updated_at')::date)
-- from evt.evt
-- where evt_type = 'leaf.inventory_transfer.import'
-- ;

-- alter table evt.evt_consumption add column entity_id_internal bigint;

select distinct
 (entity_id_external is null) missing_global_id
 ,evt_type
 ,count(*)
from evt.evt
GROUP BY
  entity_id_external is null
 ,evt_type
;

-- update evt.evt
-- set entity_id_external = params->>'global_id'
-- where evt_type = 'leaf.inventory_transfer.import'
-- ;


-- select * from auth.app_tenant limit 10;

