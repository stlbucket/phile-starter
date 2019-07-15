select
--  count(*)
name,
identifier
from auth.app_tenant
limit 20
;

select
--  count(*)
name,
external_id
from org.location
limit 20
;

select
--  count(*)
name,
external_id
from org.organization
limit 20
;


-- select *
-- from evt.evt_consumption ec
-- join evt.evt e on e.id = ec.evt_id
-- where e.evt_type = 'leaf.mme.import'
-- limit 1
-- ;


-- update evt.evt_consumption
-- set entity_id_internal = null
-- ,result = 'Captured'
-- ;