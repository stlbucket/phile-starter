-- Deploy app-roles:0010-roles to pg

BEGIN;

    DO $$
    BEGIN
        PERFORM true FROM pg_roles WHERE rolname = 'app_anonymous';
        IF NOT FOUND THEN
          CREATE ROLE app_anonymous;
        END IF;
    END;
    $$;

    DO $$
    BEGIN
        PERFORM true FROM pg_roles WHERE rolname = 'app_user';
        IF NOT FOUND THEN
          CREATE ROLE app_user;

            GRANT app_anonymous TO app_user;
        END IF;
    END;
    $$;

    DO $$
    BEGIN
        PERFORM true FROM pg_roles WHERE rolname = 'app_demon';
        IF NOT FOUND THEN
            CREATE ROLE app_demon;

            GRANT app_anonymous TO app_demon;
        END IF;
    END;
    $$;

    DO $$
    BEGIN
        PERFORM true FROM pg_roles WHERE rolname = 'app_admin';
        IF NOT FOUND THEN
            CREATE ROLE app_admin;

            GRANT app_user TO app_admin;
            GRANT app_anonymous TO app_admin;
        END IF;
    END;
    $$;

    DO $$
    BEGIN
        PERFORM true FROM pg_roles WHERE rolname = 'app_tenant_admin';
        IF NOT FOUND THEN
            CREATE ROLE app_tenant_admin;

            GRANT app_admin TO app_tenant_admin;
            GRANT app_demon TO app_tenant_admin;
            GRANT app_anonymous TO app_tenant_admin;
            GRANT app_user TO app_tenant_admin;
        END IF;

    END;
    $$;

    DO $$
    BEGIN
        PERFORM true FROM pg_roles WHERE rolname = 'app_super_admin';
        IF NOT FOUND THEN
            CREATE ROLE app_super_admin;
            
            GRANT app_tenant_admin to app_super_admin;
            GRANT app_admin TO app_super_admin;
            GRANT app_demon TO app_super_admin;
            GRANT app_anonymous TO app_super_admin;
            GRANT app_user TO app_super_admin;
        END IF;

    END;
    $$;

COMMIT;
