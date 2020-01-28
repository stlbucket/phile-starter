-- Deploy app:seed-data to pg
-- requires: schema

BEGIN;

--------------------------------------------------   lcb apps
  insert into app.application(
    name 
    ,key
  ) 
  values 
 ('Tenant Manager', 'tenant-manager')
 ,('License Manager', 'license-manager')
 ,('Address Book', 'address-book')
  on conflict(key) 
  do nothing
  ;

  insert into app.license_type(
    name
    ,key
    ,application_id
  )
  select
    a.name
    ,a.key
    ,a.id
  from app.application a
  on conflict do nothing
;

with lt as (
  select * from app.license_type where key like 'trc-%' or key = 'address-book'
)
  insert into app.license(
    app_tenant_id
    ,license_type_id
    ,name
    ,assigned_to_app_user_id
  )
  select
    au.app_tenant_id
    ,lt.id
    ,au.username || ' - ' || lt.name
    ,au.id
  from auth.app_user au
  cross join lt
  where au.permission_key in ('SuperAdmin', 'Admin', 'User')
  on conflict (assigned_to_app_user_id, license_type_id)
  do nothing
  ;


with lt as (
  select * from app.license_type where key = 'license-manager'
)
  insert into app.license(
    app_tenant_id
    ,license_type_id
    ,name
    ,assigned_to_app_user_id
  )
  select
    au.app_tenant_id
    ,lt.id
    ,au.username || ' - ' || lt.name
    ,au.id
  from auth.app_user au
  cross join lt
  where au.permission_key in ('SuperAdmin', 'Admin')
  on conflict (assigned_to_app_user_id, license_type_id)
  do nothing
  ;

with lt as (
  select * from app.license_type where key = 'tenant-manager'
)
  insert into app.license(
    app_tenant_id
    ,license_type_id
    ,name
    ,assigned_to_app_user_id
  )
  select
    au.app_tenant_id
    ,lt.id
    ,au.username || ' - ' || lt.name
    ,au.id
  from auth.app_user au
  cross join lt
  where au.permission_key in ('SuperAdmin')
  on conflict (assigned_to_app_user_id, license_type_id)
  do nothing
  ;

  COMMIT;