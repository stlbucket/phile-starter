BEGIN;

    insert into org.organization(
      app_tenant_id
      ,name
      ,external_id
    )
    select
      o.app_tenant_id
      ,o.name || ' Sub Org'
      ,o.external_id || '-sub'
    from org.organization o
    where o.external_id not like 'anchor-%'
    on conflict(app_tenant_id, external_id)
    do nothing
    ;

    insert into org.location(
      name
      ,address1
      ,address2
      ,city
      ,state
      ,zip
      ,lat
      ,lon
      ,external_id
      ,app_tenant_id
    )
    select
      o.name || ' Location'
      ,'addy 1'
      ,'addy 2'
      ,'a city'
      ,'??'
      ,'?????'
      ,(35::numeric(10,7) + (random() * 10)::numeric(10,7))::numeric(10,7)
      ,(-110::numeric(10,7) + (random() * 15)::numeric(10,7))::numeric(10,7)
      ,o.external_id
      ,o.app_tenant_id
    from org.organization o
    on conflict (app_tenant_id, external_id)
    do nothing
    ;

    update org.organization o
    set location_id = l.id
    from org.location l
    where l.external_id = o.external_id
    ;

    insert into org.location(
      name
      ,address1
      ,address2
      ,city
      ,state
      ,zip
      ,lat
      ,lon
      ,external_id
      ,app_tenant_id
    )
    select
      c.external_id || ' Location'
      ,'addy 1'
      ,'addy 2'
      ,'a city'
      ,'??'
      ,'?????'
      ,(35::numeric(10,7) + (random() * 10)::numeric(10,7))::numeric(10,7)
      ,(-110::numeric(10,7) + (random() * 15)::numeric(10,7))::numeric(10,7)
      ,c.external_id
      ,c.app_tenant_id
    from org.contact c
    on conflict
    do nothing
    ;

    update org.contact c
    set location_id = l.id
    from org.location l
    where l.external_id = c.external_id
    ;

    update org.organization o
    set primary_contact_id = (
      select id from org.contact where organization_id = o.id limit 1
    );

\echo org
select name, external_id, location_id from org.organization;
\echo contact
select email, external_id, location_id from org.contact;
\echo location
select * from org.location;

-- rollback;
COMMIT;
