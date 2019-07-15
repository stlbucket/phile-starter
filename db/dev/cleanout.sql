-- delete from org.organization where app_tenant_id not in (select id from auth.app_tenant where identifier in ('anchor', 'test-001', 'test-002', 'test-003', 'leaf-wa'));
-- delete from org.location where app_tenant_id not in (select id from auth.app_tenant where identifier in ('anchor', 'test-001', 'test-002', 'test-003', 'leaf-wa'));
-- delete from auth.app_user where app_tenant_id not in (select id from auth.app_tenant where identifier in ('anchor', 'test-001', 'test-002', 'test-003', 'leaf-wa'));
-- delete from auth.app_tenant where identifier not in ('anchor', 'test-001', 'test-002', 'test-003', 'leaf-wa');


delete from inv.strain;
delete from giant.jsd_license;
delete from org.organization where app_tenant_id in (select entity_id_internal from evt.evt_consumption where evt_id in (select id from evt.evt where evt_type = 'leaf.mme.import'));
delete from org.location where app_tenant_id in (select entity_id_internal from evt.evt_consumption where evt_id in (select id from evt.evt where evt_type = 'leaf.mme.import'));
delete from auth.app_user where app_tenant_id in (select entity_id_internal from evt.evt_consumption where evt_id in (select id from evt.evt where evt_type = 'leaf.mme.import'));
delete from auth.app_tenant where id in (select entity_id_internal from evt.evt_consumption where evt_id in (select id from evt.evt where evt_type = 'leaf.mme.import'));


update evt.evt_consumption set
  entity_id_internal = null
  ,result = 'Captured'
-- where evt_type != 'leaf.mme.import'
;


-- explain analyze
-- delete from auth.app_tenant where identifier not in ('anchor', 'test-001', 'test-002', 'test-003', 'leaf-wa');

