--
-- PostgreSQL database dump
--

\restrict 6Llqi5GUyFl40X06lVkfX9NXk7gJecn8ttbmTT1turq9JI6hE6peDvor1skTFcO

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-19 19:25:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 33 (class 2615 OID 16498)
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- TOC entry 23 (class 2615 OID 16392)
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- TOC entry 32 (class 2615 OID 16578)
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- TOC entry 31 (class 2615 OID 16567)
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- TOC entry 12 (class 2615 OID 16390)
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- TOC entry 13 (class 2615 OID 16559)
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- TOC entry 34 (class 2615 OID 16546)
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- TOC entry 30 (class 2615 OID 16607)
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- TOC entry 6 (class 3079 OID 16643)
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- TOC entry 4895 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- TOC entry 2 (class 3079 OID 16393)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- TOC entry 4896 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 4 (class 3079 OID 16447)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- TOC entry 4897 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 5 (class 3079 OID 16608)
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- TOC entry 3 (class 3079 OID 16436)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1330 (class 1247 OID 16738)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- TOC entry 1354 (class 1247 OID 16879)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- TOC entry 1327 (class 1247 OID 16732)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1324 (class 1247 OID 16727)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1372 (class 1247 OID 16982)
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1384 (class 1247 OID 17055)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1366 (class 1247 OID 16960)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1375 (class 1247 OID 16992)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1360 (class 1247 OID 16921)
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1618 (class 1247 OID 36222)
-- Name: accion_modificador_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.accion_modificador_enum AS ENUM (
    'agregar',
    'quitar',
    'sustituir'
);


ALTER TYPE public.accion_modificador_enum OWNER TO postgres;

--
-- TOC entry 1534 (class 1247 OID 23466)
-- Name: estado_orden_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_orden_enum AS ENUM (
    'pendiente',
    'en_preparacion',
    'lista',
    'entregada',
    'cancelada'
);


ALTER TYPE public.estado_orden_enum OWNER TO postgres;

--
-- TOC entry 1537 (class 1247 OID 23478)
-- Name: estado_pago_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_pago_enum AS ENUM (
    'pendiente',
    'pagado',
    'parcial'
);


ALTER TYPE public.estado_pago_enum OWNER TO postgres;

--
-- TOC entry 1546 (class 1247 OID 23527)
-- Name: estado_preparacion_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_preparacion_enum AS ENUM (
    'pendiente',
    'en_proceso',
    'listo'
);


ALTER TYPE public.estado_preparacion_enum OWNER TO postgres;

--
-- TOC entry 1540 (class 1247 OID 23486)
-- Name: metodo_pago_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.metodo_pago_enum AS ENUM (
    'efectivo',
    'tarjeta',
    'transferencia',
    'multiple',
    'cortesia'
);


ALTER TYPE public.metodo_pago_enum OWNER TO postgres;

--
-- TOC entry 1501 (class 1247 OID 22175)
-- Name: tipo_ingrediente_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_ingrediente_enum AS ENUM (
    'obligatorio',
    'opcional',
    'extra'
);


ALTER TYPE public.tipo_ingrediente_enum OWNER TO postgres;

--
-- TOC entry 1531 (class 1247 OID 23459)
-- Name: tipo_orden_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_orden_enum AS ENUM (
    'local',
    'para_llevar',
    'delivery'
);


ALTER TYPE public.tipo_orden_enum OWNER TO postgres;

--
-- TOC entry 1582 (class 1247 OID 31600)
-- Name: tipo_promocion_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_promocion_enum AS ENUM (
    '2x1',
    '3x2',
    'descuento_porcentaje',
    'descuento_fijo',
    'precio_especial'
);


ALTER TYPE public.tipo_promocion_enum OWNER TO postgres;

--
-- TOC entry 1414 (class 1247 OID 17166)
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- TOC entry 1396 (class 1247 OID 17126)
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- TOC entry 1399 (class 1247 OID 17141)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- TOC entry 1420 (class 1247 OID 17208)
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- TOC entry 1417 (class 1247 OID 17179)
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- TOC entry 1444 (class 1247 OID 17426)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- TOC entry 670 (class 1255 OID 16544)
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 670
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 661 (class 1255 OID 16709)
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- TOC entry 668 (class 1255 OID 16543)
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 668
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 675 (class 1255 OID 16542)
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 675
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 666 (class 1255 OID 16551)
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 666
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 580 (class 1255 OID 16572)
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 580
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 534 (class 1255 OID 16553)
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 534
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 493 (class 1255 OID 16563)
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- TOC entry 503 (class 1255 OID 16564)
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- TOC entry 564 (class 1255 OID 16574)
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 564
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 506 (class 1255 OID 16391)
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- TOC entry 591 (class 1255 OID 21022)
-- Name: actualizar_perfil_usuario(integer, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_perfil_usuario(p_id integer, p_nuevo_nombre text, p_nueva_contra text) RETURNS TABLE(mensaje text, exito boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE usuarios 
    SET 
        nombre_usuario = COALESCE(p_nuevo_nombre, nombre_usuario),
        contra = COALESCE(p_nueva_contra, contra)
    WHERE id_usuario = p_id;

    RETURN QUERY SELECT 'Perfil actualizado con éxito'::TEXT, true;

EXCEPTION 
    WHEN unique_violation THEN
        RETURN QUERY SELECT 'Ese nombre de usuario ya está en uso'::TEXT, false;
    WHEN OTHERS THEN
        RETURN QUERY SELECT 'Error al actualizar: ' || SQLERRM, false;
END;
$$;


ALTER FUNCTION public.actualizar_perfil_usuario(p_id integer, p_nuevo_nombre text, p_nueva_contra text) OWNER TO postgres;

--
-- TOC entry 647 (class 1255 OID 21021)
-- Name: alta_beneficio(character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alta_beneficio(p_nombre character varying, p_descripcion text) RETURNS TABLE(mensaje text, exito boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO tipo_beneficio (nombre, descripcion)
    VALUES (p_nombre, p_descripcion);

    RETURN QUERY SELECT 'Tipo de beneficio registrado con éxito'::TEXT, true;

EXCEPTION 
    WHEN unique_violation THEN
        RETURN QUERY SELECT 'Ya existe un beneficio con ese nombre'::TEXT, false;
    WHEN OTHERS THEN
        RETURN QUERY SELECT 'Error, intente de nuevo ' || SQLERRM, false;
END;
$$;


ALTER FUNCTION public.alta_beneficio(p_nombre character varying, p_descripcion text) OWNER TO postgres;

--
-- TOC entry 525 (class 1255 OID 20975)
-- Name: alta_cliente(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alta_cliente(p_nombre character varying, p_email character varying, p_telefono character varying) RETURNS TABLE(mensaje text, exito boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO clientes (nombre, email, telefono, codigo_rfid, activo)
    VALUES (p_nombre, p_email, p_telefono, NULL, true); -- Insertamos NULL directamente

    RETURN QUERY SELECT 'Cliente registrado con exito (sin RFID)'::TEXT, true;

EXCEPTION 
    WHEN unique_violation THEN
        RETURN QUERY SELECT 'Email registrado'::TEXT, false;
    WHEN OTHERS THEN
        RETURN QUERY SELECT 'Error: ' || SQLERRM, false;
END;
$$;


ALTER FUNCTION public.alta_cliente(p_nombre character varying, p_email character varying, p_telefono character varying) OWNER TO postgres;

--
-- TOC entry 579 (class 1255 OID 20960)
-- Name: alta_usuario(text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.alta_usuario(p_nombre text, p_contra text, p_rol integer) RETURNS TABLE(mensaje text, exito boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Intentamos insertar el nuevo usuario
    INSERT INTO usuarios (nombre_usuario, contra, id_rol)
    VALUES (p_nombre, p_contra, p_rol);

    RETURN QUERY SELECT 'Usuario registrado con éxito'::TEXT, true;

EXCEPTION 
    WHEN unique_violation THEN
        RETURN QUERY SELECT 'El nombre de usuario ya existe'::TEXT, false;
    WHEN OTHERS THEN
        RETURN QUERY SELECT 'Error inesperado: ' || SQLERRM, false;
END;
$$;


ALTER FUNCTION public.alta_usuario(p_nombre text, p_contra text, p_rol integer) OWNER TO postgres;

--
-- TOC entry 514 (class 1255 OID 20976)
-- Name: asignar_rfid_cliente(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.asignar_rfid_cliente(p_id integer, p_rfid character varying) RETURNS TABLE(mensaje text, exito boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Corregido: Usamos p_rfid (el nombre exacto del parámetro)
    UPDATE clientes 
    SET codigo_rfid = p_rfid 
    WHERE id_cliente = p_id;

    IF FOUND THEN
        RETURN QUERY SELECT 'RFID vinculado con éxito'::TEXT, true;
    ELSE
        RETURN QUERY SELECT 'No se encontró el cliente con ID ' || p_id, false;
    END IF;

EXCEPTION 
    WHEN unique_violation THEN
        RETURN QUERY SELECT 'Este código RFID ya pertenece a otro cliente'::TEXT, false;
    WHEN OTHERS THEN
        RETURN QUERY SELECT 'Error: ' || SQLERRM, false;
END;
$$;


ALTER FUNCTION public.asignar_rfid_cliente(p_id integer, p_rfid character varying) OWNER TO postgres;

--
-- TOC entry 639 (class 1255 OID 20963)
-- Name: baja_usuario_por_nombre(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.baja_usuario_por_nombre(p_nombre text) RETURNS TABLE(mensaje text, exito boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM usuarios WHERE nombre_usuario = p_nombre;

    IF FOUND THEN
        RETURN QUERY SELECT 'Usuario eliminado de la cafetería'::TEXT, true;
    ELSE
        RETURN QUERY SELECT 'El usuario no existe'::TEXT, false;
    END IF;
END;
$$;


ALTER FUNCTION public.baja_usuario_por_nombre(p_nombre text) OWNER TO postgres;

--
-- TOC entry 539 (class 1255 OID 23615)
-- Name: fn_actualizar_categoria(integer, character varying, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_categoria(p_id integer, p_nombre character varying DEFAULT NULL::character varying, p_descripcion text DEFAULT NULL::text, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM categoria WHERE id_categoria = p_id
    ) THEN
        RETURN 'La categoría no existe';
    END IF;

    -- Validar nombre si viene
    IF p_nombre IS NOT NULL AND TRIM(p_nombre) = '' THEN
        RETURN 'Nombre inválido';
    END IF;

    -- Evitar duplicados
    IF p_nombre IS NOT NULL AND EXISTS (
        SELECT 1 FROM categoria
        WHERE LOWER(nombre_cat) = LOWER(p_nombre)
        AND id_categoria <> p_id
        AND activo = TRUE
    ) THEN
        RETURN 'Ya existe otra categoría con ese nombre';
    END IF;

    UPDATE categoria
    SET
        nombre_cat = COALESCE(p_nombre, nombre_cat),
        descripcion_cat = COALESCE(p_descripcion, descripcion_cat),
        activo = COALESCE(p_activo, activo)
    WHERE id_categoria = p_id;

    RETURN 'Categoría actualizada';
END;
$$;


ALTER FUNCTION public.fn_actualizar_categoria(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 538 (class 1255 OID 35062)
-- Name: fn_actualizar_cliente_beneficio(integer, integer, integer, date, date, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_cliente_beneficio(p_id integer, p_cantidad_disponible integer DEFAULT NULL::integer, p_cantidad_usada integer DEFAULT NULL::integer, p_fecha_inicio date DEFAULT NULL::date, p_fecha_fin date DEFAULT NULL::date, p_dias character varying DEFAULT NULL::character varying, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM cliente_beneficio WHERE id_cliente_beneficio = p_id
    ) THEN
        RETURN 'No existe el registro';
    END IF;

    IF p_cantidad_disponible IS NOT NULL AND p_cantidad_disponible < 0 THEN
        RETURN 'Cantidad inválida';
    END IF;

    UPDATE cliente_beneficio
    SET
        cantidad_disponible = COALESCE(p_cantidad_disponible, cantidad_disponible),
        cantidad_usada = COALESCE(p_cantidad_usada, cantidad_usada),
        fecha_inicio = COALESCE(p_fecha_inicio, fecha_inicio),
        fecha_fin = COALESCE(p_fecha_fin, fecha_fin),
        dias_aplica = COALESCE(p_dias, dias_aplica),
        activo = COALESCE(p_activo, activo)
    WHERE id_cliente_beneficio = p_id;

    RETURN 'Beneficio actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_cliente_beneficio(p_id integer, p_cantidad_disponible integer, p_cantidad_usada integer, p_fecha_inicio date, p_fecha_fin date, p_dias character varying, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 618 (class 1255 OID 23609)
-- Name: fn_actualizar_ingrediente(integer, character varying, public.tipo_ingrediente_enum, numeric, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_ingrediente(p_id integer, p_nombre character varying DEFAULT NULL::character varying, p_tipo public.tipo_ingrediente_enum DEFAULT NULL::public.tipo_ingrediente_enum, p_precio numeric DEFAULT NULL::numeric, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM ingredientes WHERE id_ingrediente = p_id
    ) THEN
        RETURN 'El ingrediente no existe';
    END IF;

    -- Validación
    IF p_precio IS NOT NULL AND p_precio < 0 THEN
        RETURN 'Precio inválido';
    END IF;

    UPDATE ingredientes
    SET
        nombre_ingrediente = COALESCE(p_nombre, nombre_ingrediente),
        tipo_ingrediente = COALESCE(p_tipo, tipo_ingrediente),
        precio_adicional = COALESCE(p_precio, precio_adicional),
        activo = COALESCE(p_activo, activo)
    WHERE id_ingrediente = p_id;

    RETURN 'Ingrediente actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_ingrediente(p_id integer, p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 535 (class 1255 OID 41718)
-- Name: fn_actualizar_inventario(integer, numeric, numeric, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_inventario(p_id_inventario integer, p_cantidad_actual numeric DEFAULT NULL::numeric, p_cantidad_minima numeric DEFAULT NULL::numeric, p_unidad character varying DEFAULT NULL::character varying, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Validar existencia
    IF NOT EXISTS (
        SELECT 1 FROM inventario WHERE id_inventario = p_id_inventario
    ) THEN
        RETURN 'Inventario no existe';
    END IF;

    -- Update con COALESCE
    UPDATE inventario
    SET 
        cantidad_actual = COALESCE(p_cantidad_actual, cantidad_actual),
        cantidad_minima = COALESCE(p_cantidad_minima, cantidad_minima),
        unidad = COALESCE(p_unidad, unidad),
        activo = COALESCE(p_activo, activo),
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_inventario = p_id_inventario;

    RETURN 'Inventario actualizado correctamente';
END;
$$;


ALTER FUNCTION public.fn_actualizar_inventario(p_id_inventario integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 654 (class 1255 OID 23592)
-- Name: fn_actualizar_menu(integer, character varying, text, time without time zone, time without time zone, character varying, date, date, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_menu(p_id_menu integer, p_nombre_menu character varying DEFAULT NULL::character varying, p_descripcion text DEFAULT NULL::text, p_hora_inicio time without time zone DEFAULT NULL::time without time zone, p_hora_fin time without time zone DEFAULT NULL::time without time zone, p_dias_semana character varying DEFAULT NULL::character varying, p_fecha_inicio date DEFAULT NULL::date, p_fecha_fin date DEFAULT NULL::date, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Validar existencia
    IF NOT EXISTS (
        SELECT 1 FROM menus WHERE id_menu = p_id_menu
    ) THEN
        RETURN 'El menú no existe';
    END IF;

    -- Validación de horas (solo si ambas vienen)
    IF p_hora_inicio IS NOT NULL 
       AND p_hora_fin IS NOT NULL 
       AND p_hora_fin <= p_hora_inicio THEN
        RETURN 'hora_fin debe ser mayor que hora_inicio';
    END IF;

    -- Validación de fechas
    IF p_fecha_inicio IS NOT NULL 
       AND p_fecha_fin IS NOT NULL 
       AND p_fecha_fin < p_fecha_inicio THEN
        RETURN 'fecha_fin no puede ser menor a fecha_inicio';
    END IF;

    UPDATE menus
    SET
        nombre_menu = COALESCE(p_nombre_menu, nombre_menu),
        descripcion = COALESCE(p_descripcion, descripcion),
        hora_inicio = COALESCE(p_hora_inicio, hora_inicio),
        hora_fin = COALESCE(p_hora_fin, hora_fin),
        dias_semana = COALESCE(p_dias_semana, dias_semana),
        fecha_inicio = COALESCE(p_fecha_inicio, fecha_inicio),
        fecha_fin = COALESCE(p_fecha_fin, fecha_fin),
        activo = COALESCE(p_activo, activo)
    WHERE id_menu = p_id_menu;

    RETURN 'Menú actualizado correctamente';
END;
$$;


ALTER FUNCTION public.fn_actualizar_menu(p_id_menu integer, p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 610 (class 1255 OID 36281)
-- Name: fn_actualizar_ops(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_ops(p_id integer, p_cantidad integer DEFAULT NULL::integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM orden_paquete_selecciones 
        WHERE id_seleccion = p_id
    ) THEN
        RETURN 'No existe la selección';
    END IF;

    IF p_cantidad IS NOT NULL AND p_cantidad <= 0 THEN
        RETURN 'Cantidad inválida';
    END IF;

    UPDATE orden_paquete_selecciones
    SET
        cantidad = COALESCE(p_cantidad, cantidad)
    WHERE id_seleccion = p_id;

    RETURN 'Selección actualizada';
END;
$$;


ALTER FUNCTION public.fn_actualizar_ops(p_id integer, p_cantidad integer) OWNER TO postgres;

--
-- TOC entry 509 (class 1255 OID 31583)
-- Name: fn_actualizar_orden(integer, public.estado_orden_enum, public.estado_pago_enum, public.metodo_pago_enum, numeric, numeric, numeric, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_orden(p_id integer, p_estado_orden public.estado_orden_enum DEFAULT NULL::public.estado_orden_enum, p_estado_pago public.estado_pago_enum DEFAULT NULL::public.estado_pago_enum, p_metodo_pago public.metodo_pago_enum DEFAULT NULL::public.metodo_pago_enum, p_descuento numeric DEFAULT NULL::numeric, p_impuestos numeric DEFAULT NULL::numeric, p_total numeric DEFAULT NULL::numeric, p_notas text DEFAULT NULL::text, p_fecha_entrega timestamp without time zone DEFAULT NULL::timestamp without time zone) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM ordenes WHERE id_orden = p_id
    ) THEN
        RETURN 'La orden no existe';
    END IF;

    -- Validación
    IF p_total IS NOT NULL AND p_total < 0 THEN
        RETURN 'Total inválido';
    END IF;

    UPDATE ordenes
    SET
        estado_orden = COALESCE(p_estado_orden, estado_orden),
        estado_pago = COALESCE(p_estado_pago, estado_pago),
        metodo_pago = COALESCE(p_metodo_pago, metodo_pago),
        descuento = COALESCE(p_descuento, descuento),
        impuestos = COALESCE(p_impuestos, impuestos),
        total = COALESCE(p_total, total),
        notas_orden = COALESCE(p_notas, notas_orden),
        fecha_entrega = COALESCE(p_fecha_entrega, fecha_entrega),
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_orden = p_id;

    RETURN 'Orden actualizada';
END;
$$;


ALTER FUNCTION public.fn_actualizar_orden(p_id integer, p_estado_orden public.estado_orden_enum, p_estado_pago public.estado_pago_enum, p_metodo_pago public.metodo_pago_enum, p_descuento numeric, p_impuestos numeric, p_total numeric, p_notas text, p_fecha_entrega timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 532 (class 1255 OID 36220)
-- Name: fn_actualizar_orden_detalle(integer, integer, numeric, numeric, numeric, public.estado_preparacion_enum, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_orden_detalle(p_id integer, p_cantidad integer DEFAULT NULL::integer, p_precio_unitario numeric DEFAULT NULL::numeric, p_descuento numeric DEFAULT NULL::numeric, p_subtotal numeric DEFAULT NULL::numeric, p_estado public.estado_preparacion_enum DEFAULT NULL::public.estado_preparacion_enum, p_notas text DEFAULT NULL::text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM orden_detalles WHERE id_orden_detalle = p_id
    ) THEN
        RETURN 'No existe el detalle';
    END IF;

    UPDATE orden_detalles
    SET
        cantidad = COALESCE(p_cantidad, cantidad),
        precio_unitario = COALESCE(p_precio_unitario, precio_unitario),
        descuento_aplicado = COALESCE(p_descuento, descuento_aplicado),
        subtotal = COALESCE(p_subtotal, subtotal),
        estado_preparacion = COALESCE(p_estado, estado_preparacion),
        notas_especiales = COALESCE(p_notas, notas_especiales)
    WHERE id_orden_detalle = p_id;

    RETURN 'Detalle actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_orden_detalle(p_id integer, p_cantidad integer, p_precio_unitario numeric, p_descuento numeric, p_subtotal numeric, p_estado public.estado_preparacion_enum, p_notas text) OWNER TO postgres;

--
-- TOC entry 561 (class 1255 OID 36253)
-- Name: fn_actualizar_orden_modificador(integer, public.accion_modificador_enum, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_orden_modificador(p_id integer, p_accion public.accion_modificador_enum DEFAULT NULL::public.accion_modificador_enum, p_precio numeric DEFAULT NULL::numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM orden_detalle_modificadores 
        WHERE id_detalle_modificador = p_id
    ) THEN
        RETURN 'No existe el modificador';
    END IF;

    UPDATE orden_detalle_modificadores
    SET
        accion = COALESCE(p_accion, accion),
        precio_modificador = COALESCE(p_precio, precio_modificador)
    WHERE id_detalle_modificador = p_id;

    RETURN 'Modificador actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_orden_modificador(p_id integer, p_accion public.accion_modificador_enum, p_precio numeric) OWNER TO postgres;

--
-- TOC entry 657 (class 1255 OID 36477)
-- Name: fn_actualizar_pago(integer, public.metodo_pago_enum, numeric, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_pago(p_id_pago integer, p_metodo_pago public.metodo_pago_enum DEFAULT NULL::public.metodo_pago_enum, p_monto numeric DEFAULT NULL::numeric, p_referencia character varying DEFAULT NULL::character varying, p_id_usuario integer DEFAULT NULL::integer, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM orden_pagos WHERE id_pago = p_id_pago
    ) THEN
        RETURN 'Pago no existe';
    END IF;

    IF p_monto IS NOT NULL AND p_monto <= 0 THEN
        RETURN 'Monto inválido';
    END IF;

    UPDATE orden_pagos
    SET
        metodo_pago = COALESCE(p_metodo_pago, metodo_pago),
        monto_pagado = COALESCE(p_monto, monto_pagado),
        referencia = COALESCE(p_referencia, referencia),
        id_usuario = COALESCE(p_id_usuario, id_usuario),
        activo = COALESCE(p_activo, activo)
    WHERE id_pago = p_id_pago;

    RETURN 'Pago actualizado correctamente';
END;
$$;


ALTER FUNCTION public.fn_actualizar_pago(p_id_pago integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 665 (class 1255 OID 23576)
-- Name: fn_actualizar_paquete(integer, character varying, text, numeric, boolean, timestamp without time zone, timestamp without time zone, character varying, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_paquete(p_id_paquete integer, p_nombre_paquete character varying DEFAULT NULL::character varying, p_descripcion text DEFAULT NULL::text, p_precio_paquete numeric DEFAULT NULL::numeric, p_es_temporal boolean DEFAULT NULL::boolean, p_fecha_inicio timestamp without time zone DEFAULT NULL::timestamp without time zone, p_fecha_fin timestamp without time zone DEFAULT NULL::timestamp without time zone, p_dias_disponibles character varying DEFAULT NULL::character varying, p_url_imagen text DEFAULT NULL::text, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM paquetes WHERE id_paquete = p_id_paquete
    ) THEN
        RETURN 'El paquete no existe';
    END IF;

    -- Validación de precio
    IF p_precio_paquete IS NOT NULL AND p_precio_paquete <= 0 THEN
        RETURN 'Precio inválido';
    END IF;

    -- Validación de fechas
    IF p_fecha_inicio IS NOT NULL AND p_fecha_fin IS NOT NULL AND p_fecha_fin < p_fecha_inicio THEN
        RETURN 'fecha_fin no puede ser menor a fecha_inicio';
    END IF;

    UPDATE paquetes
    SET
        nombre_paquete = COALESCE(p_nombre_paquete, nombre_paquete),
        descripcion = COALESCE(p_descripcion, descripcion),
        precio_paquete = COALESCE(p_precio_paquete, precio_paquete),
        es_temporal = COALESCE(p_es_temporal, es_temporal),
        fecha_inicio = COALESCE(p_fecha_inicio, fecha_inicio),
        fecha_fin = COALESCE(p_fecha_fin, fecha_fin),
        dias_disponibles = COALESCE(p_dias_disponibles, dias_disponibles),
        url_imagen = COALESCE(p_url_imagen, url_imagen),
        activo = COALESCE(p_activo, activo)
    WHERE id_paquete = p_id_paquete;

    RETURN 'Paquete actualizado correctamente';
END;
$$;


ALTER FUNCTION public.fn_actualizar_paquete(p_id_paquete integer, p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 572 (class 1255 OID 23582)
-- Name: fn_actualizar_paquete_grupo(integer, character varying, boolean, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_paquete_grupo(p_id integer, p_nombre_grupo character varying DEFAULT NULL::character varying, p_seleccion_obligatoria boolean DEFAULT NULL::boolean, p_cantidad_selecciones integer DEFAULT NULL::integer, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM paquete_grupos WHERE id_paquete_grupo = p_id
    ) THEN
        RETURN 'El grupo no existe';
    END IF;

    IF p_cantidad_selecciones IS NOT NULL AND p_cantidad_selecciones <= 0 THEN
        RETURN 'cantidad_selecciones inválida';
    END IF;

    UPDATE paquete_grupos
    SET
        nombre_grupo = COALESCE(p_nombre_grupo, nombre_grupo),
        seleccion_obligatoria = COALESCE(p_seleccion_obligatoria, seleccion_obligatoria),
        cantidad_selecciones = COALESCE(p_cantidad_selecciones, cantidad_selecciones),
        activo = COALESCE(p_activo, activo)
    WHERE id_paquete_grupo = p_id;

    RETURN 'Grupo actualizado correctamente';
END;
$$;


ALTER FUNCTION public.fn_actualizar_paquete_grupo(p_id integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 537 (class 1255 OID 23585)
-- Name: fn_actualizar_paquete_grupo_productos(integer, integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_paquete_grupo_productos(p_id_grupo integer, p_id_producto integer, p_precio numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF p_precio < 0 THEN
        RETURN 'Precio inválido';
    END IF;

    UPDATE paquete_grupo_productos
    SET precio_adicional = p_precio
    WHERE id_paquete_grupo = p_id_grupo
    AND id_producto = p_id_producto;

    IF NOT FOUND THEN
        RETURN 'Relación no encontrada';
    END IF;

    RETURN 'Precio actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_paquete_grupo_productos(p_id_grupo integer, p_id_producto integer, p_precio numeric) OWNER TO postgres;

--
-- TOC entry 630 (class 1255 OID 23584)
-- Name: fn_actualizar_precio_extra(integer, integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_precio_extra(p_id_grupo integer, p_id_producto integer, p_precio numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF p_precio < 0 THEN
        RETURN 'Precio inválido';
    END IF;

    UPDATE paquete_grupo_productos
    SET precio_adicional = p_precio
    WHERE id_paquete_grupo = p_id_grupo
    AND id_producto = p_id_producto;

    IF NOT FOUND THEN
        RETURN 'Relación no encontrada';
    END IF;

    RETURN 'Precio actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_precio_extra(p_id_grupo integer, p_id_producto integer, p_precio numeric) OWNER TO postgres;

--
-- TOC entry 559 (class 1255 OID 24834)
-- Name: fn_actualizar_producto(integer, character varying, text, numeric, integer, integer, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_producto(p_id_producto integer, p_nombre_producto character varying DEFAULT NULL::character varying, p_descripcion text DEFAULT NULL::text, p_precio_base numeric DEFAULT NULL::numeric, p_id_zona integer DEFAULT NULL::integer, p_id_categoria integer DEFAULT NULL::integer, p_url_imagen text DEFAULT NULL::text, p_disponibilidad boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Validar que exista
    IF NOT EXISTS (
        SELECT 1 FROM productos WHERE id_producto = p_id_producto
    ) THEN
        RETURN 'Producto no existe';
    END IF;

    -- Validación de precio (solo si viene valor)
    IF p_precio_base IS NOT NULL AND p_precio_base <= 0 THEN
        RETURN 'Precio inválido';
    END IF;

    -- Update con COALESCE
    UPDATE productos
    SET 
        nombre_producto = COALESCE(p_nombre_producto, nombre_producto),
        descripcion_pro = COALESCE(p_descripcion, descripcion_pro),
        precio_base = COALESCE(p_precio_base, precio_base),
        id_zona = COALESCE(p_id_zona, id_zona),
        id_categoria = COALESCE(p_id_categoria, id_categoria),
        url_imagen = COALESCE(p_url_imagen, url_imagen),
        disponibilidad = COALESCE(p_disponibilidad, disponibilidad)
    WHERE id_producto = p_id_producto;

    RETURN 'Producto actualizado correctamente';
END;
$$;


ALTER FUNCTION public.fn_actualizar_producto(p_id_producto integer, p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text, p_disponibilidad boolean) OWNER TO postgres;

--
-- TOC entry 497 (class 1255 OID 23612)
-- Name: fn_actualizar_producto_ingrediente(integer, boolean, numeric, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_producto_ingrediente(p_id integer, p_es_obligatorio boolean DEFAULT NULL::boolean, p_precio numeric DEFAULT NULL::numeric, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM producto_ingrediente 
        WHERE id_producto_ingrediente = p_id
    ) THEN
        RETURN 'Relación no existe';
    END IF;

    IF p_precio IS NOT NULL AND p_precio < 0 THEN
        RETURN 'Precio inválido';
    END IF;

    UPDATE producto_ingrediente
    SET
        es_obligatorio = COALESCE(p_es_obligatorio, es_obligatorio),
        precio_modificador = COALESCE(p_precio, precio_modificador),
        activo = COALESCE(p_activo, activo)
    WHERE id_producto_ingrediente = p_id;

    RETURN 'Relación actualizada';
END;
$$;


ALTER FUNCTION public.fn_actualizar_producto_ingrediente(p_id integer, p_es_obligatorio boolean, p_precio numeric, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 558 (class 1255 OID 31631)
-- Name: fn_actualizar_promocion(integer, character varying, text, public.tipo_promocion_enum, numeric, boolean, timestamp without time zone, timestamp without time zone, time without time zone, time without time zone, text[], boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_promocion(p_id integer, p_nombre character varying DEFAULT NULL::character varying, p_descripcion text DEFAULT NULL::text, p_tipo public.tipo_promocion_enum DEFAULT NULL::public.tipo_promocion_enum, p_valor numeric DEFAULT NULL::numeric, p_es_temporal boolean DEFAULT NULL::boolean, p_fecha_inicio timestamp without time zone DEFAULT NULL::timestamp without time zone, p_fecha_fin timestamp without time zone DEFAULT NULL::timestamp without time zone, p_hora_inicio time without time zone DEFAULT NULL::time without time zone, p_hora_fin time without time zone DEFAULT NULL::time without time zone, p_dias text[] DEFAULT NULL::text[], p_es_permanente boolean DEFAULT NULL::boolean, p_solo_clientes boolean DEFAULT NULL::boolean, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM promociones WHERE id_promocion = p_id
    ) THEN
        RETURN 'La promoción no existe';
    END IF;

    IF p_valor IS NOT NULL AND p_valor < 0 THEN
        RETURN 'Valor inválido';
    END IF;

    UPDATE promociones
    SET
        nombre_promocion = COALESCE(p_nombre, nombre_promocion),
        descripcion = COALESCE(p_descripcion, descripcion),
        tipo_promocion = COALESCE(p_tipo, tipo_promocion),
        valor_descuento = COALESCE(p_valor, valor_descuento),
        es_temporal = COALESCE(p_es_temporal, es_temporal),
        fecha_inicio = COALESCE(p_fecha_inicio, fecha_inicio),
        fecha_fin = COALESCE(p_fecha_fin, fecha_fin),
        hora_inicio = COALESCE(p_hora_inicio, hora_inicio),
        hora_fin = COALESCE(p_hora_fin, hora_fin),
        dias_aplicables = COALESCE(p_dias, dias_aplicables),
        es_permanente = COALESCE(p_es_permanente, es_permanente),
        solo_clientes_registrados = COALESCE(p_solo_clientes, solo_clientes_registrados),
        activo = COALESCE(p_activo, activo)
    WHERE id_promocion = p_id;

    RETURN 'Promoción actualizada';
END;
$$;


ALTER FUNCTION public.fn_actualizar_promocion(p_id integer, p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 636 (class 1255 OID 23648)
-- Name: fn_actualizar_tipo_beneficio(integer, character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying DEFAULT NULL::character varying, p_descripcion text DEFAULT NULL::text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM tipo_beneficio WHERE id_tipo_beneficio = p_id
    ) THEN
        RETURN 'No existe el tipo de beneficio';
    END IF;

    -- Validar nombre
    IF p_nombre IS NOT NULL AND TRIM(p_nombre) = '' THEN
        RETURN 'Nombre inválido';
    END IF;

    -- Evitar duplicados
    IF p_nombre IS NOT NULL AND EXISTS (
        SELECT 1 FROM tipo_beneficio
        WHERE LOWER(nombre) = LOWER(p_nombre)
        AND id_tipo_beneficio <> p_id
    ) THEN
        RETURN 'Ya existe otro con ese nombre';
    END IF;

    UPDATE tipo_beneficio
    SET
        nombre = COALESCE(p_nombre, nombre),
        descripcion = COALESCE(p_descripcion, descripcion)
    WHERE id_tipo_beneficio = p_id;

    RETURN 'Tipo de beneficio actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text) OWNER TO postgres;

--
-- TOC entry 505 (class 1255 OID 42036)
-- Name: fn_actualizar_tipo_beneficio(integer, character varying, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying DEFAULT NULL::character varying, p_descripcion text DEFAULT NULL::text, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM tipo_beneficio 
        WHERE id_tipo_beneficio = p_id
    ) THEN
        RETURN 'No existe el tipo de beneficio';
    END IF;

    -- Validar nombre
    IF p_nombre IS NOT NULL 
       AND TRIM(p_nombre) = '' THEN
        RETURN 'Nombre inválido';
    END IF;

    -- Evitar duplicados
    IF p_nombre IS NOT NULL 
       AND EXISTS (
            SELECT 1 
            FROM tipo_beneficio
            WHERE LOWER(nombre) = LOWER(p_nombre)
            AND id_tipo_beneficio <> p_id
        ) THEN
        RETURN 'Ya existe otro con ese nombre';
    END IF;

    UPDATE tipo_beneficio
    SET
        nombre = COALESCE(p_nombre, nombre),
        descripcion = COALESCE(p_descripcion, descripcion),
        activo = COALESCE(p_activo, activo)

    WHERE id_tipo_beneficio = p_id;

    RETURN 'Tipo de beneficio actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 520 (class 1255 OID 36500)
-- Name: fn_actualizar_uso_beneficio(integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_uso_beneficio(p_id_uso_beneficio integer, p_cantidad integer DEFAULT NULL::integer, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM uso_beneficios 
        WHERE id_uso_beneficio = p_id_uso_beneficio
    ) THEN
        RETURN 'Registro no existe';
    END IF;

    IF p_cantidad IS NOT NULL AND p_cantidad <= 0 THEN
        RETURN 'Cantidad inválida';
    END IF;

    UPDATE uso_beneficios
    SET
        cantidad_usada = COALESCE(p_cantidad, cantidad_usada),
        activo = COALESCE(p_activo, activo)
    WHERE id_uso_beneficio = p_id_uso_beneficio;

    RETURN 'Uso de beneficio actualizado';
END;
$$;


ALTER FUNCTION public.fn_actualizar_uso_beneficio(p_id_uso_beneficio integer, p_cantidad integer, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 662 (class 1255 OID 23618)
-- Name: fn_actualizar_zona(integer, character varying, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_actualizar_zona(p_id integer, p_nombre character varying DEFAULT NULL::character varying, p_descripcion text DEFAULT NULL::text, p_activo boolean DEFAULT NULL::boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM zonas WHERE id_zona = p_id
    ) THEN
        RETURN 'La zona no existe';
    END IF;

    -- Validar nombre
    IF p_nombre IS NOT NULL AND TRIM(p_nombre) = '' THEN
        RETURN 'Nombre inválido';
    END IF;

    -- Evitar duplicados
    IF p_nombre IS NOT NULL AND EXISTS (
        SELECT 1 FROM zonas
        WHERE LOWER(nombre_zona) = LOWER(p_nombre)
        AND id_zona <> p_id
        AND activo = TRUE
    ) THEN
        RETURN 'Ya existe otra zona con ese nombre';
    END IF;

    UPDATE zonas
    SET
        nombre_zona = COALESCE(p_nombre, nombre_zona),
        descripcion_zona = COALESCE(p_descripcion, descripcion_zona),
        activo = COALESCE(p_activo, activo)
    WHERE id_zona = p_id;

    RETURN 'Zona actualizada';
END;
$$;


ALTER FUNCTION public.fn_actualizar_zona(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) OWNER TO postgres;

--
-- TOC entry 640 (class 1255 OID 23613)
-- Name: fn_alta_categoria(character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_categoria(p_nombre character varying, p_descripcion text DEFAULT NULL::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validar nombre vacío
    IF TRIM(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre de la categoría no puede estar vacío';
    END IF;

    -- Evitar duplicados activos
    IF EXISTS (
        SELECT 1 FROM categoria
        WHERE LOWER(nombre_cat) = LOWER(p_nombre)
        AND activo = TRUE
    ) THEN
        RAISE EXCEPTION 'La categoría ya existe';
    END IF;

    INSERT INTO categoria (
        nombre_cat,
        descripcion_cat
    )
    VALUES (
        p_nombre,
        p_descripcion
    )
    RETURNING id_categoria INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_categoria(p_nombre character varying, p_descripcion text) OWNER TO postgres;

--
-- TOC entry 614 (class 1255 OID 35060)
-- Name: fn_alta_cliente_beneficio(integer, integer, date, integer, date, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_cliente_beneficio(p_id_cliente integer, p_id_tipo_beneficio integer, p_fecha_inicio date, p_cantidad integer DEFAULT 0, p_fecha_fin date DEFAULT NULL::date, p_dias character varying DEFAULT NULL::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    IF p_cantidad < 0 THEN
        RAISE EXCEPTION 'Cantidad no puede ser negativa';
    END IF;

    INSERT INTO cliente_beneficio (
        id_cliente,
        id_tipo_beneficio,
        cantidad_disponible,
        fecha_inicio,
        fecha_fin,
        dias_aplica
    )
    VALUES (
        p_id_cliente,
        p_id_tipo_beneficio,
        p_cantidad,
        p_fecha_inicio,
        p_fecha_fin,
        p_dias
    )
    RETURNING id_cliente_beneficio INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_cliente_beneficio(p_id_cliente integer, p_id_tipo_beneficio integer, p_fecha_inicio date, p_cantidad integer, p_fecha_fin date, p_dias character varying) OWNER TO postgres;

--
-- TOC entry 541 (class 1255 OID 23601)
-- Name: fn_alta_ingrediente(character varying, public.tipo_ingrediente_enum, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_ingrediente(p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validación
    IF p_precio < 0 THEN
        RAISE EXCEPTION 'El precio no puede ser negativo';
    END IF;

    INSERT INTO ingredientes (
        nombre_ingrediente,
        tipo_ingrediente,
        precio_adicional
    )
    VALUES (
        p_nombre,
        p_tipo,
        p_precio
    )
    RETURNING id_ingrediente INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_ingrediente(p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric) OWNER TO postgres;

--
-- TOC entry 631 (class 1255 OID 41716)
-- Name: fn_alta_inventario(integer, numeric, numeric, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_inventario(p_id_ingrediente integer, p_cantidad_actual numeric DEFAULT 0, p_cantidad_minima numeric DEFAULT 0, p_unidad character varying DEFAULT NULL::character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Validar ingrediente
    IF NOT EXISTS (
        SELECT 1 FROM ingredientes WHERE id_ingrediente = p_id_ingrediente
    ) THEN
        RETURN 'Ingrediente no existe';
    END IF;

    -- Insert
    INSERT INTO inventario (
        id_ingrediente,
        cantidad_actual,
        cantidad_minima,
        unidad
    )
    VALUES (
        p_id_ingrediente,
        COALESCE(p_cantidad_actual, 0),
        COALESCE(p_cantidad_minima, 0),
        p_unidad
    );

    RETURN 'Inventario registrado correctamente';
END;
$$;


ALTER FUNCTION public.fn_alta_inventario(p_id_ingrediente integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying) OWNER TO postgres;

--
-- TOC entry 595 (class 1255 OID 23590)
-- Name: fn_alta_menu(character varying, text, time without time zone, time without time zone, character varying, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_menu(p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date DEFAULT NULL::date, p_fecha_fin date DEFAULT NULL::date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validaciones
    IF p_hora_fin <= p_hora_inicio THEN
        RAISE EXCEPTION 'La hora_fin debe ser mayor que hora_inicio';
    END IF;

    IF p_fecha_inicio IS NOT NULL AND p_fecha_fin IS NOT NULL 
       AND p_fecha_fin < p_fecha_inicio THEN
        RAISE EXCEPTION 'fecha_fin no puede ser menor a fecha_inicio';
    END IF;

    INSERT INTO menus (
        nombre_menu,
        descripcion,
        hora_inicio,
        hora_fin,
        dias_semana,
        fecha_inicio,
        fecha_fin
    )
    VALUES (
        p_nombre_menu,
        p_descripcion,
        p_hora_inicio,
        p_hora_fin,
        p_dias_semana,
        p_fecha_inicio,
        p_fecha_fin
    )
    RETURNING id_menu INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_menu(p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date) OWNER TO postgres;

--
-- TOC entry 553 (class 1255 OID 23594)
-- Name: fn_alta_menu_producto(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_menu_producto(p_id_menu integer, p_id_producto integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Validar menú
    IF NOT EXISTS (
        SELECT 1 FROM menus WHERE id_menu = p_id_menu
    ) THEN
        RETURN 'El menú no existe';
    END IF;

    -- Validar producto
    IF NOT EXISTS (
        SELECT 1 FROM productos WHERE id_producto = p_id_producto
    ) THEN
        RETURN 'El producto no existe';
    END IF;

    -- Evitar duplicados
    IF EXISTS (
        SELECT 1 FROM menu_productos
        WHERE id_menu = p_id_menu
        AND id_producto = p_id_producto
    ) THEN
        RETURN 'El producto ya está en el menú';
    END IF;

    INSERT INTO menu_productos (id_menu, id_producto)
    VALUES (p_id_menu, p_id_producto);

    RETURN 'Producto agregado al menú';
END;
$$;


ALTER FUNCTION public.fn_alta_menu_producto(p_id_menu integer, p_id_producto integer) OWNER TO postgres;

--
-- TOC entry 569 (class 1255 OID 41734)
-- Name: fn_alta_movimiento(integer, character varying, numeric, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_movimiento(p_id_inventario integer, p_tipo_movimiento character varying, p_cantidad numeric, p_motivo text DEFAULT NULL::text, p_id_usuario integer DEFAULT NULL::integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Validar inventario
    IF NOT EXISTS (
        SELECT 1 FROM inventario WHERE id_inventario = p_id_inventario
    ) THEN
        RETURN 'Inventario no existe';
    END IF;

    -- Validar cantidad
    IF p_cantidad <= 0 THEN
        RETURN 'Cantidad inválida';
    END IF;

    -- Insertar movimiento
    INSERT INTO inventario_movimientos (
        id_inventario,
        tipo_movimiento,
        cantidad,
        motivo,
        id_usuario
    )
    VALUES (
        p_id_inventario,
        p_tipo_movimiento,
        p_cantidad,
        p_motivo,
        p_id_usuario
    );

    -- Aplicar cambio al inventario
    IF p_tipo_movimiento = 'entrada' THEN
        UPDATE inventario
        SET cantidad_actual = cantidad_actual + p_cantidad,
            fecha_actualizacion = CURRENT_TIMESTAMP
        WHERE id_inventario = p_id_inventario;

    ELSIF p_tipo_movimiento = 'salida' THEN
        UPDATE inventario
        SET cantidad_actual = cantidad_actual - p_cantidad,
            fecha_actualizacion = CURRENT_TIMESTAMP
        WHERE id_inventario = p_id_inventario;

    ELSIF p_tipo_movimiento = 'ajuste' THEN
        UPDATE inventario
        SET cantidad_actual = p_cantidad,
            fecha_actualizacion = CURRENT_TIMESTAMP
        WHERE id_inventario = p_id_inventario;
    END IF;

    RETURN 'Movimiento registrado correctamente';
END;
$$;


ALTER FUNCTION public.fn_alta_movimiento(p_id_inventario integer, p_tipo_movimiento character varying, p_cantidad numeric, p_motivo text, p_id_usuario integer) OWNER TO postgres;

--
-- TOC entry 511 (class 1255 OID 36279)
-- Name: fn_alta_ops(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_ops(p_id_detalle integer, p_id_grupo integer, p_id_producto integer, p_cantidad integer DEFAULT 1) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    IF p_cantidad <= 0 THEN
        RAISE EXCEPTION 'Cantidad inválida';
    END IF;

    INSERT INTO orden_paquete_selecciones (
        id_orden_detalle,
        id_paquete_grupo,
        id_producto,
        cantidad
    )
    VALUES (
        p_id_detalle,
        p_id_grupo,
        p_id_producto,
        p_cantidad
    )
    RETURNING id_seleccion INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_ops(p_id_detalle integer, p_id_grupo integer, p_id_producto integer, p_cantidad integer) OWNER TO postgres;

--
-- TOC entry 674 (class 1255 OID 31581)
-- Name: fn_alta_orden(character varying, integer, numeric, numeric, integer, public.tipo_orden_enum, character varying, numeric, numeric, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_orden(p_numero_orden character varying, p_id_usuario integer, p_subtotal numeric, p_total numeric, p_id_cliente integer DEFAULT NULL::integer, p_tipo_orden public.tipo_orden_enum DEFAULT 'local'::public.tipo_orden_enum, p_mesa_numero character varying DEFAULT NULL::character varying, p_descuento numeric DEFAULT NULL::numeric, p_impuestos numeric DEFAULT NULL::numeric, p_notas text DEFAULT NULL::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- 🔴 Validar número de orden único
    IF EXISTS (
        SELECT 1 FROM ordenes WHERE numero_orden = p_numero_orden
    ) THEN
        RAISE EXCEPTION 'El número de orden ya existe';
    END IF;

    -- 🔴 Validar usuario
    IF NOT EXISTS (
        SELECT 1 FROM usuarios WHERE id_usuario = p_id_usuario
    ) THEN
        RAISE EXCEPTION 'El usuario no existe';
    END IF;

    -- 🟡 Validar cliente (solo si se manda)
    IF p_id_cliente IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM clientes WHERE id_cliente = p_id_cliente
    ) THEN
        RAISE EXCEPTION 'El cliente no existe';
    END IF;

    -- 🔴 Validar montos
    IF p_subtotal < 0 OR p_total < 0 THEN
        RAISE EXCEPTION 'Los montos no pueden ser negativos';
    END IF;

    -- 🟡 Validar consistencia básica (opcional pero pro)
    IF p_total < p_subtotal THEN
        RAISE EXCEPTION 'El total no puede ser menor al subtotal';
    END IF;

    -- 🟢 Insertar orden
    INSERT INTO ordenes (
        numero_orden,
        id_usuario,
        id_cliente,
        tipo_orden,
        mesa_numero,
        subtotal,
        descuento,
        impuestos,
        total,
        notas_orden
    )
    VALUES (
        p_numero_orden,
        p_id_usuario,
        p_id_cliente,
        COALESCE(p_tipo_orden, 'local'),
        p_mesa_numero,
        p_subtotal,
        COALESCE(p_descuento, 0),
        COALESCE(p_impuestos, 0),
        p_total,
        p_notas
    )
    RETURNING id_orden INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_orden(p_numero_orden character varying, p_id_usuario integer, p_subtotal numeric, p_total numeric, p_id_cliente integer, p_tipo_orden public.tipo_orden_enum, p_mesa_numero character varying, p_descuento numeric, p_impuestos numeric, p_notas text) OWNER TO postgres;

--
-- TOC entry 533 (class 1255 OID 36525)
-- Name: fn_alta_orden_detalle(integer, integer, numeric, numeric, integer, integer, numeric, integer, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_orden_detalle(p_id_orden integer, p_cantidad integer, p_precio_unitario numeric, p_subtotal numeric, p_id_producto integer DEFAULT NULL::integer, p_id_paquete integer DEFAULT NULL::integer, p_descuento numeric DEFAULT 0, p_id_promocion integer DEFAULT NULL::integer, p_id_zona integer DEFAULT NULL::integer, p_notas text DEFAULT NULL::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validaciones
    IF p_cantidad <= 0 THEN
        RAISE EXCEPTION 'Cantidad inválida';
    END IF;

    IF p_precio_unitario < 0 OR p_subtotal < 0 THEN
        RAISE EXCEPTION 'Montos inválidos';
    END IF;

    IF p_id_producto IS NULL AND p_id_paquete IS NULL THEN
        RAISE EXCEPTION 'Debe especificar producto o paquete';
    END IF;

    INSERT INTO orden_detalles (
        id_orden,
        id_producto,
        id_paquete,
        cantidad,
        precio_unitario,
        descuento_aplicado,
        subtotal,
        id_promocion,
        id_zona,
        notas_especiales
    )
    VALUES (
        p_id_orden,
        p_id_producto,
        p_id_paquete,
        p_cantidad,
        p_precio_unitario,
        p_descuento,
        p_subtotal,
        p_id_promocion,
        p_id_zona,
        p_notas
    )
    RETURNING id_orden_detalle INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_orden_detalle(p_id_orden integer, p_cantidad integer, p_precio_unitario numeric, p_subtotal numeric, p_id_producto integer, p_id_paquete integer, p_descuento numeric, p_id_promocion integer, p_id_zona integer, p_notas text) OWNER TO postgres;

--
-- TOC entry 623 (class 1255 OID 36527)
-- Name: fn_alta_orden_modifica(integer, integer, public.accion_modificador_enum, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_orden_modifica(p_id_detalle integer, p_id_ingrediente integer, p_accion public.accion_modificador_enum DEFAULT 'agregar'::public.accion_modificador_enum, p_precio numeric DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    IF p_precio < 0 THEN
        RAISE EXCEPTION 'Precio inválido';
    END IF;

    INSERT INTO orden_detalle_modificadores (
        id_orden_detalle,
        id_ingrediente,
        accion,
        precio_modificador
    )
    VALUES (
        p_id_detalle,
        p_id_ingrediente,
        p_accion,
        p_precio
    )
    RETURNING id_detalle_modificador INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_orden_modifica(p_id_detalle integer, p_id_ingrediente integer, p_accion public.accion_modificador_enum, p_precio numeric) OWNER TO postgres;

--
-- TOC entry 590 (class 1255 OID 36475)
-- Name: fn_alta_pago(integer, public.metodo_pago_enum, numeric, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_pago(p_id_orden integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying DEFAULT NULL::character varying, p_id_usuario integer DEFAULT NULL::integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_total NUMERIC;
    v_pagado NUMERIC;
BEGIN
    -- Validar monto
    IF p_monto <= 0 THEN
        RETURN 'Monto inválido';
    END IF;

    -- Validar orden
    IF NOT EXISTS (
        SELECT 1 FROM ordenes WHERE id_orden = p_id_orden
    ) THEN
        RETURN 'Orden no existe';
    END IF;

    -- Obtener total de la orden
    SELECT total INTO v_total
    FROM ordenes
    WHERE id_orden = p_id_orden;

    -- Sumar pagos actuales
    SELECT COALESCE(SUM(monto_pagado), 0)
    INTO v_pagado
    FROM orden_pagos
    WHERE id_orden = p_id_orden
    AND activo = TRUE;

    -- Validar sobrepago
    IF (v_pagado + p_monto) > v_total THEN
        RETURN 'El monto excede el total de la orden';
    END IF;

    -- Insertar pago
    INSERT INTO orden_pagos (
        id_orden,
        metodo_pago,
        monto_pagado,
        referencia,
        id_usuario
    )
    VALUES (
        p_id_orden,
        p_metodo_pago,
        p_monto,
        p_referencia,
        p_id_usuario
    );

    -- Recalcular total pagado
    SELECT COALESCE(SUM(monto_pagado), 0)
    INTO v_pagado
    FROM orden_pagos
    WHERE id_orden = p_id_orden
    AND activo = TRUE;

    -- Actualizar estado
    IF v_pagado = v_total THEN
        UPDATE ordenes
        SET 
            estado_pago = 'pagado',
            metodo_pago = p_metodo_pago
        WHERE id_orden = p_id_orden;

        RETURN 'Pago completo registrado';
    ELSE
        RETURN 'Pago parcial registrado';
    END IF;
END;
$$;


ALTER FUNCTION public.fn_alta_pago(p_id_orden integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer) OWNER TO postgres;

--
-- TOC entry 517 (class 1255 OID 23574)
-- Name: fn_alta_paquete(character varying, text, numeric, boolean, timestamp without time zone, timestamp without time zone, character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_paquete(p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean DEFAULT false, p_fecha_inicio timestamp without time zone DEFAULT NULL::timestamp without time zone, p_fecha_fin timestamp without time zone DEFAULT NULL::timestamp without time zone, p_dias_disponibles character varying DEFAULT NULL::character varying, p_url_imagen text DEFAULT NULL::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_paquete INT;
BEGIN
    -- Validaciones
    IF p_precio_paquete <= 0 THEN
        RAISE EXCEPTION 'El precio del paquete debe ser mayor a 0';
    END IF;

    IF p_es_temporal = TRUE AND (p_fecha_inicio IS NULL OR p_fecha_fin IS NULL) THEN
        RAISE EXCEPTION 'Debe indicar fecha_inicio y fecha_fin para paquetes temporales';
    END IF;

    IF p_fecha_fin IS NOT NULL AND p_fecha_inicio IS NOT NULL AND p_fecha_fin < p_fecha_inicio THEN
        RAISE EXCEPTION 'fecha_fin no puede ser menor a fecha_inicio';
    END IF;

    INSERT INTO paquetes (
        nombre_paquete,
        descripcion,
        precio_paquete,
        es_temporal,
        fecha_inicio,
        fecha_fin,
        dias_disponibles,
        url_imagen
    )
    VALUES (
        p_nombre_paquete,
        p_descripcion,
        p_precio_paquete,
        p_es_temporal,
        p_fecha_inicio,
        p_fecha_fin,
        p_dias_disponibles,
        p_url_imagen
    )
    RETURNING id_paquete INTO v_id_paquete;

    RETURN v_id_paquete;
END;
$$;


ALTER FUNCTION public.fn_alta_paquete(p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text) OWNER TO postgres;

--
-- TOC entry 529 (class 1255 OID 23578)
-- Name: fn_alta_paquete_grupo(integer, character varying, boolean, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_paquete_grupo(p_id_paquete integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean DEFAULT true, p_cantidad_selecciones integer DEFAULT 1) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validar paquete existente
    IF NOT EXISTS (
        SELECT 1 FROM paquetes WHERE id_paquete = p_id_paquete
    ) THEN
        RAISE EXCEPTION 'El paquete no existe';
    END IF;

    -- Validación
    IF p_cantidad_selecciones <= 0 THEN
        RAISE EXCEPTION 'cantidad_selecciones debe ser mayor a 0';
    END IF;

    INSERT INTO paquete_grupos (
        id_paquete,
        nombre_grupo,
        seleccion_obligatoria,
        cantidad_selecciones
    )
    VALUES (
        p_id_paquete,
        p_nombre_grupo,
        p_seleccion_obligatoria,
        p_cantidad_selecciones
    )
    RETURNING id_paquete_grupo INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_paquete_grupo(p_id_paquete integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer) OWNER TO postgres;

--
-- TOC entry 482 (class 1255 OID 23583)
-- Name: fn_alta_paquete_grupo_producto(integer, integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer, p_precio_adicional numeric DEFAULT 0) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Validar duplicado
    IF EXISTS (
        SELECT 1 FROM paquete_grupo_productos
        WHERE id_paquete_grupo = p_id_grupo
        AND id_producto = p_id_producto
    ) THEN
        RETURN 'Ya existe esta relación';
    END IF;

    INSERT INTO paquete_grupo_productos (
        id_paquete_grupo,
        id_producto,
        precio_adicional
    )
    VALUES (
        p_id_grupo,
        p_id_producto,
        p_precio_adicional
    );

    RETURN 'Producto agregado al grupo';
END;
$$;


ALTER FUNCTION public.fn_alta_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer, p_precio_adicional numeric) OWNER TO postgres;

--
-- TOC entry 577 (class 1255 OID 23577)
-- Name: fn_alta_permiso(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_permiso(p_nombre_permiso character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_permiso INT;
BEGIN
    INSERT INTO permisos (nombre_permiso)
    VALUES (p_nombre_permiso)
    RETURNING id_permiso INTO v_id_permiso;

    RETURN v_id_permiso;
END;
$$;


ALTER FUNCTION public.fn_alta_permiso(p_nombre_permiso character varying) OWNER TO postgres;

--
-- TOC entry 663 (class 1255 OID 23565)
-- Name: fn_alta_producto(character varying, text, numeric, integer, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_producto(p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text DEFAULT NULL::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_producto INT;
BEGIN
    IF p_precio_base <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser mayor a 0';
    END IF;

    INSERT INTO productos (
        nombre_producto,
        descripcion_pro,
        precio_base,
        id_zona,
        id_categoria,
        url_imagen
    )
    VALUES (
        p_nombre_producto,
        p_descripcion,
        p_precio_base,
        p_id_zona,
        p_id_categoria,
        p_url_imagen
    )
    RETURNING id_producto INTO v_id_producto;

    RETURN v_id_producto;
END;
$$;


ALTER FUNCTION public.fn_alta_producto(p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text) OWNER TO postgres;

--
-- TOC entry 575 (class 1255 OID 23610)
-- Name: fn_alta_producto_ingrediente(integer, integer, boolean, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_producto_ingrediente(p_id_producto integer, p_id_ingrediente integer, p_es_obligatorio boolean DEFAULT false, p_precio numeric DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validar existencia
    IF NOT EXISTS (
        SELECT 1 FROM productos WHERE id_producto = p_id_producto
    ) THEN
        RAISE EXCEPTION 'El producto no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM ingredientes WHERE id_ingrediente = p_id_ingrediente
    ) THEN
        RAISE EXCEPTION 'El ingrediente no existe';
    END IF;

    -- Validar precio
    IF p_precio < 0 THEN
        RAISE EXCEPTION 'El precio no puede ser negativo';
    END IF;

    -- Evitar duplicados activos
    IF EXISTS (
        SELECT 1 FROM producto_ingrediente
        WHERE id_producto = p_id_producto
        AND id_ingrediente = p_id_ingrediente
        AND activo = TRUE
    ) THEN
        RAISE EXCEPTION 'El ingrediente ya está asignado a este producto';
    END IF;

    INSERT INTO producto_ingrediente (
        id_producto,
        id_ingrediente,
        es_obligatorio,
        precio_modificador
    )
    VALUES (
        p_id_producto,
        p_id_ingrediente,
        p_es_obligatorio,
        p_precio
    )
    RETURNING id_producto_ingrediente INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_producto_ingrediente(p_id_producto integer, p_id_ingrediente integer, p_es_obligatorio boolean, p_precio numeric) OWNER TO postgres;

--
-- TOC entry 602 (class 1255 OID 31629)
-- Name: fn_alta_promocion(character varying, text, public.tipo_promocion_enum, numeric, boolean, timestamp without time zone, timestamp without time zone, time without time zone, time without time zone, text[], boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_promocion(p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean DEFAULT false, p_fecha_inicio timestamp without time zone DEFAULT NULL::timestamp without time zone, p_fecha_fin timestamp without time zone DEFAULT NULL::timestamp without time zone, p_hora_inicio time without time zone DEFAULT NULL::time without time zone, p_hora_fin time without time zone DEFAULT NULL::time without time zone, p_dias text[] DEFAULT NULL::text[], p_es_permanente boolean DEFAULT false, p_solo_clientes boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validación
    IF p_valor < 0 THEN
        RAISE EXCEPTION 'El valor no puede ser negativo';
    END IF;

    INSERT INTO promociones (
        nombre_promocion,
        descripcion,
        tipo_promocion,
        valor_descuento,
        es_temporal,
        fecha_inicio,
        fecha_fin,
        hora_inicio,
        hora_fin,
        dias_aplicables,
        es_permanente,
        solo_clientes_registrados
    )
    VALUES (
        p_nombre,
        p_descripcion,
        p_tipo,
        p_valor,
        p_es_temporal,
        p_fecha_inicio,
        p_fecha_fin,
        p_hora_inicio,
        p_hora_fin,
        p_dias,
        p_es_permanente,
        p_solo_clientes
    )
    RETURNING id_promocion INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_promocion(p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean) OWNER TO postgres;

--
-- TOC entry 548 (class 1255 OID 36431)
-- Name: fn_alta_promocion_cliente(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_promocion_cliente(p_id_promocion integer, p_id_cliente integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO promocion_clientes (id_promocion, id_cliente)
    VALUES (p_id_promocion, p_id_cliente);

    RETURN 'Cliente asignado a promoción';

EXCEPTION 
    WHEN unique_violation THEN
        RETURN 'El cliente ya tiene esta promoción';
END;
$$;


ALTER FUNCTION public.fn_alta_promocion_cliente(p_id_promocion integer, p_id_cliente integer) OWNER TO postgres;

--
-- TOC entry 629 (class 1255 OID 31680)
-- Name: fn_alta_promocion_paquete(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_promocion_paquete(p_id_promocion integer, p_id_paquete integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO promocion_paquetes (id_promocion, id_paquete)
    VALUES (p_id_promocion, p_id_paquete);

    RETURN 'Paquete asignado a promoción';

EXCEPTION 
    WHEN unique_violation THEN
        RETURN 'El paquete ya está en esta promoción';
END;
$$;


ALTER FUNCTION public.fn_alta_promocion_paquete(p_id_promocion integer, p_id_paquete integer) OWNER TO postgres;

--
-- TOC entry 669 (class 1255 OID 31652)
-- Name: fn_alta_promocion_producto(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_promocion_producto(p_id_promocion integer, p_id_producto integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO promocion_productos (id_promocion, id_producto)
    VALUES (p_id_promocion, p_id_producto);

    RETURN 'Producto asignado a promoción';
    
EXCEPTION 
    WHEN unique_violation THEN
        RETURN 'El producto ya está en esta promoción';
END;
$$;


ALTER FUNCTION public.fn_alta_promocion_producto(p_id_promocion integer, p_id_producto integer) OWNER TO postgres;

--
-- TOC entry 549 (class 1255 OID 23567)
-- Name: fn_alta_rol(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_rol(p_nombre_rol character varying, p_descripcion character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_rol INT;
BEGIN
    INSERT INTO roles (nombre_rol, descripcion)
    VALUES (p_nombre_rol, p_descripcion)
    RETURNING id_rol INTO v_id_rol;

    RETURN v_id_rol;
END;
$$;


ALTER FUNCTION public.fn_alta_rol(p_nombre_rol character varying, p_descripcion character varying) OWNER TO postgres;

--
-- TOC entry 536 (class 1255 OID 23625)
-- Name: fn_alta_tipo_beneficio(character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_tipo_beneficio(p_nombre character varying, p_descripcion text DEFAULT NULL::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validar nombre
    IF TRIM(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre no puede estar vacío';
    END IF;

    -- Si existe inactivo → reactivar
    IF EXISTS (
        SELECT 1 
        FROM tipo_beneficio
        WHERE LOWER(nombre) = LOWER(p_nombre)
        AND activo = FALSE
    ) THEN

        UPDATE tipo_beneficio
        SET
            activo = TRUE,
            descripcion = COALESCE(p_descripcion, descripcion)
        WHERE LOWER(nombre) = LOWER(p_nombre);

        SELECT id_tipo_beneficio
        INTO v_id
        FROM tipo_beneficio
        WHERE LOWER(nombre) = LOWER(p_nombre);

        RETURN v_id;
    END IF;

    -- Evitar duplicados activos
    IF EXISTS (
        SELECT 1 
        FROM tipo_beneficio
        WHERE LOWER(nombre) = LOWER(p_nombre)
        AND activo = TRUE
    ) THEN
        RAISE EXCEPTION 'El tipo de beneficio ya existe';
    END IF;

    -- Insert normal
    INSERT INTO tipo_beneficio (
        nombre,
        descripcion
    )
    VALUES (
        p_nombre,
        p_descripcion
    )
    RETURNING id_tipo_beneficio INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_tipo_beneficio(p_nombre character varying, p_descripcion text) OWNER TO postgres;

--
-- TOC entry 551 (class 1255 OID 36498)
-- Name: fn_alta_uso_beneficio(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_uso_beneficio(p_id_cliente_beneficio integer, p_id_orden integer, p_cantidad integer DEFAULT 1) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF p_cantidad <= 0 THEN
        RETURN 'Cantidad inválida';
    END IF;

    INSERT INTO uso_beneficios (
        id_cliente_beneficio,
        id_orden,
        cantidad_usada
    )
    VALUES (
        p_id_cliente_beneficio,
        p_id_orden,
        p_cantidad
    );

    RETURN 'Uso de beneficio registrado';
END;
$$;


ALTER FUNCTION public.fn_alta_uso_beneficio(p_id_cliente_beneficio integer, p_id_orden integer, p_cantidad integer) OWNER TO postgres;

--
-- TOC entry 596 (class 1255 OID 23616)
-- Name: fn_alta_zona(character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_alta_zona(p_nombre character varying, p_descripcion text DEFAULT NULL::text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    -- Validar nombre
    IF TRIM(p_nombre) = '' THEN
        RAISE EXCEPTION 'El nombre de la zona no puede estar vacío';
    END IF;

    -- Evitar duplicados activos
    IF EXISTS (
        SELECT 1 FROM zonas
        WHERE LOWER(nombre_zona) = LOWER(p_nombre)
        AND activo = TRUE
    ) THEN
        RAISE EXCEPTION 'La zona ya existe';
    END IF;

    INSERT INTO zonas (
        nombre_zona,
        descripcion_zona
    )
    VALUES (
        p_nombre,
        p_descripcion
    )
    RETURNING id_zona INTO v_id;

    RETURN v_id;
END;
$$;


ALTER FUNCTION public.fn_alta_zona(p_nombre character varying, p_descripcion text) OWNER TO postgres;

--
-- TOC entry 624 (class 1255 OID 23599)
-- Name: fn_asignar_permiso(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_asignar_permiso(p_id_rol integer, p_id_permiso integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO rol_permiso (id_rol, id_permiso)
    VALUES (p_id_rol, p_id_permiso);
    RETURN TRUE;
EXCEPTION WHEN unique_violation THEN
    -- Si ya existe esa combinación, no hace nada y avisa
    RETURN FALSE; 
END;
$$;


ALTER FUNCTION public.fn_asignar_permiso(p_id_rol integer, p_id_permiso integer) OWNER TO postgres;

--
-- TOC entry 634 (class 1255 OID 23614)
-- Name: fn_baja_categoria(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_categoria(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM categoria WHERE id_categoria = p_id
    ) THEN
        RETURN 'La categoría no existe';
    END IF;

    IF EXISTS (
        SELECT 1 FROM categoria 
        WHERE id_categoria = p_id AND activo = FALSE
    ) THEN
        RETURN 'La categoría ya está inactiva';
    END IF;

    UPDATE categoria
    SET activo = FALSE
    WHERE id_categoria = p_id;

    RETURN 'Categoría desactivada';
END;
$$;


ALTER FUNCTION public.fn_baja_categoria(p_id integer) OWNER TO postgres;

--
-- TOC entry 646 (class 1255 OID 35061)
-- Name: fn_baja_cliente_beneficio(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_cliente_beneficio(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM cliente_beneficio WHERE id_cliente_beneficio = p_id
    ) THEN
        RETURN 'No existe el registro';
    END IF;

    UPDATE cliente_beneficio
    SET activo = FALSE
    WHERE id_cliente_beneficio = p_id;

    RETURN 'Beneficio desactivado';
END;
$$;


ALTER FUNCTION public.fn_baja_cliente_beneficio(p_id integer) OWNER TO postgres;

--
-- TOC entry 545 (class 1255 OID 23608)
-- Name: fn_baja_ingrediente(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_ingrediente(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM ingredientes WHERE id_ingrediente = p_id
    ) THEN
        RETURN 'El ingrediente no existe';
    END IF;

    IF EXISTS (
        SELECT 1 FROM ingredientes 
        WHERE id_ingrediente = p_id AND activo = FALSE
    ) THEN
        RETURN 'El ingrediente ya está inactivo';
    END IF;

    UPDATE ingredientes
    SET activo = FALSE
    WHERE id_ingrediente = p_id;

    RETURN 'Ingrediente desactivado';
END;
$$;


ALTER FUNCTION public.fn_baja_ingrediente(p_id integer) OWNER TO postgres;

--
-- TOC entry 578 (class 1255 OID 41717)
-- Name: fn_baja_inventario(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_inventario(p_id_inventario integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM inventario WHERE id_inventario = p_id_inventario
    ) THEN
        RETURN 'Registro no existe';
    END IF;

    UPDATE inventario
    SET activo = FALSE
    WHERE id_inventario = p_id_inventario;

    RETURN 'Inventario desactivado';
END;
$$;


ALTER FUNCTION public.fn_baja_inventario(p_id_inventario integer) OWNER TO postgres;

--
-- TOC entry 490 (class 1255 OID 23591)
-- Name: fn_baja_menu(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_menu(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM menus WHERE id_menu = p_id
    ) THEN
        RETURN 'El menú no existe';
    END IF;

    UPDATE menus
    SET activo = FALSE
    WHERE id_menu = p_id;

    RETURN 'Menú desactivado';
END;
$$;


ALTER FUNCTION public.fn_baja_menu(p_id integer) OWNER TO postgres;

--
-- TOC entry 598 (class 1255 OID 36280)
-- Name: fn_baja_ops(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_ops(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM orden_paquete_selecciones 
        WHERE id_seleccion = p_id
    ) THEN
        RETURN 'No existe la selección';
    END IF;

    DELETE FROM orden_paquete_selecciones
    WHERE id_seleccion = p_id;

    RETURN 'Selección eliminada';
END;
$$;


ALTER FUNCTION public.fn_baja_ops(p_id integer) OWNER TO postgres;

--
-- TOC entry 492 (class 1255 OID 31582)
-- Name: fn_baja_orden(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_orden(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM ordenes WHERE id_orden = p_id
    ) THEN
        RETURN 'La orden no existe';
    END IF;

    UPDATE ordenes
    SET 
        estado_orden = 'cancelada',
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_orden = p_id;

    RETURN 'Orden cancelada';
END;
$$;


ALTER FUNCTION public.fn_baja_orden(p_id integer) OWNER TO postgres;

--
-- TOC entry 589 (class 1255 OID 36526)
-- Name: fn_baja_orden_detalle(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_orden_detalle(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM orden_detalles WHERE id_orden_detalle = p_id
    ) THEN
        RETURN 'No existe el detalle';
    END IF;

    DELETE FROM orden_detalles
    WHERE id_orden_detalle = p_id;

    RETURN 'Detalle eliminado';
END;
$$;


ALTER FUNCTION public.fn_baja_orden_detalle(p_id integer) OWNER TO postgres;

--
-- TOC entry 599 (class 1255 OID 36528)
-- Name: fn_baja_orden_modificador(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_orden_modificador(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM orden_detalle_modificadores 
        WHERE id_detalle_modificador = p_id
    ) THEN
        RETURN 'No existe el modificador';
    END IF;

    DELETE FROM orden_detalle_modificadores
    WHERE id_detalle_modificador = p_id;

    RETURN 'Modificador eliminado';
END;
$$;


ALTER FUNCTION public.fn_baja_orden_modificador(p_id integer) OWNER TO postgres;

--
-- TOC entry 483 (class 1255 OID 36476)
-- Name: fn_baja_pago(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_pago(p_id_pago integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM orden_pagos WHERE id_pago = p_id_pago
    ) THEN
        RETURN 'Pago no existe';
    END IF;

    UPDATE orden_pagos
    SET activo = FALSE
    WHERE id_pago = p_id_pago;

    RETURN 'Pago desactivado';
END;
$$;


ALTER FUNCTION public.fn_baja_pago(p_id_pago integer) OWNER TO postgres;

--
-- TOC entry 672 (class 1255 OID 23575)
-- Name: fn_baja_paquete(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_paquete(p_id_paquete integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM paquetes WHERE id_paquete = p_id_paquete
    ) THEN
        RETURN 'El paquete no existe';
    END IF;

    IF EXISTS (
        SELECT 1 FROM paquetes 
        WHERE id_paquete = p_id_paquete AND activo = FALSE
    ) THEN
        RETURN 'El paquete ya está inactivo';
    END IF;

    UPDATE paquetes
    SET activo = FALSE
    WHERE id_paquete = p_id_paquete;

    RETURN 'Paquete desactivado correctamente';
END;
$$;


ALTER FUNCTION public.fn_baja_paquete(p_id_paquete integer) OWNER TO postgres;

--
-- TOC entry 527 (class 1255 OID 23581)
-- Name: fn_baja_paquete_grupo(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_paquete_grupo(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM paquete_grupos WHERE id_paquete_grupo = p_id
    ) THEN
        RETURN 'El grupo no existe';
    END IF;

    IF EXISTS (
        SELECT 1 FROM paquete_grupos 
        WHERE id_paquete_grupo = p_id AND activo = FALSE
    ) THEN
        RETURN 'El grupo ya está inactivo';
    END IF;

    UPDATE paquete_grupos
    SET activo = FALSE
    WHERE id_paquete_grupo = p_id;

    RETURN 'Grupo desactivado correctamente';
END;
$$;


ALTER FUNCTION public.fn_baja_paquete_grupo(p_id integer) OWNER TO postgres;

--
-- TOC entry 588 (class 1255 OID 35040)
-- Name: fn_baja_paquete_grupo_producto(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM paquete_grupo_productos
    WHERE id_paquete_grupo = p_id_grupo
    AND id_producto = p_id_producto;

    IF NOT FOUND THEN
        RETURN 'No existe la relación';
    END IF;

    RETURN 'Relación eliminada';
END;
$$;


ALTER FUNCTION public.fn_baja_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer) OWNER TO postgres;

--
-- TOC entry 637 (class 1255 OID 23593)
-- Name: fn_baja_permiso(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_permiso(p_id_permiso integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM permisos WHERE id_permiso = p_id_permiso;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.fn_baja_permiso(p_id_permiso integer) OWNER TO postgres;

--
-- TOC entry 653 (class 1255 OID 23566)
-- Name: fn_baja_producto(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_producto(p_id_producto integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE productos
    SET disponibilidad = FALSE
    WHERE id_producto = p_id_producto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Producto no encontrado';
    END IF;
END;
$$;


ALTER FUNCTION public.fn_baja_producto(p_id_producto integer) OWNER TO postgres;

--
-- TOC entry 645 (class 1255 OID 23611)
-- Name: fn_baja_producto_ingrediente(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_producto_ingrediente(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM producto_ingrediente 
        WHERE id_producto_ingrediente = p_id
    ) THEN
        RETURN 'Relación no existe';
    END IF;

    UPDATE producto_ingrediente
    SET activo = FALSE
    WHERE id_producto_ingrediente = p_id;

    RETURN 'Relación desactivada';
END;
$$;


ALTER FUNCTION public.fn_baja_producto_ingrediente(p_id integer) OWNER TO postgres;

--
-- TOC entry 524 (class 1255 OID 31630)
-- Name: fn_baja_promocion(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_promocion(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM promociones WHERE id_promocion = p_id
    ) THEN
        RETURN 'La promoción no existe';
    END IF;

    UPDATE promociones
    SET activo = FALSE
    WHERE id_promocion = p_id;

    RETURN 'Promoción desactivada';
END;
$$;


ALTER FUNCTION public.fn_baja_promocion(p_id integer) OWNER TO postgres;

--
-- TOC entry 487 (class 1255 OID 31703)
-- Name: fn_baja_promocion_cliente(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_promocion_cliente(p_id_promocion integer, p_id_cliente integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM promocion_clientes
    WHERE id_promocion = p_id_promocion
    AND id_cliente = p_id_cliente;

    RETURN 'Cliente eliminado de la promoción';
END;
$$;


ALTER FUNCTION public.fn_baja_promocion_cliente(p_id_promocion integer, p_id_cliente integer) OWNER TO postgres;

--
-- TOC entry 516 (class 1255 OID 31681)
-- Name: fn_baja_promocion_paquete(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_promocion_paquete(p_id_promocion integer, p_id_paquete integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM promocion_paquetes
    WHERE id_promocion = p_id_promocion
    AND id_paquete = p_id_paquete;

    RETURN 'Paquete eliminado de la promoción';
END;
$$;


ALTER FUNCTION public.fn_baja_promocion_paquete(p_id_promocion integer, p_id_paquete integer) OWNER TO postgres;

--
-- TOC entry 478 (class 1255 OID 31653)
-- Name: fn_baja_promocion_producto(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_promocion_producto(p_id_promocion integer, p_id_producto integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM promocion_productos
    WHERE id_promocion = p_id_promocion
    AND id_producto = p_id_producto;

    RETURN 'Producto eliminado de la promoción';
END;
$$;


ALTER FUNCTION public.fn_baja_promocion_producto(p_id_promocion integer, p_id_producto integer) OWNER TO postgres;

--
-- TOC entry 635 (class 1255 OID 23568)
-- Name: fn_baja_rol(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_rol(p_id_rol integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM roles WHERE id_rol = p_id_rol;
    
    -- Retorna true si se eliminó algo, false si el ID no existía
    RETURN FOUND; 
END;
$$;


ALTER FUNCTION public.fn_baja_rol(p_id_rol integer) OWNER TO postgres;

--
-- TOC entry 601 (class 1255 OID 23647)
-- Name: fn_baja_tipo_beneficio(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_tipo_beneficio(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM tipo_beneficio 
        WHERE id_tipo_beneficio = p_id
    ) THEN
        RETURN 'No existe el tipo de beneficio';
    END IF;

    UPDATE tipo_beneficio
    SET activo = FALSE
    WHERE id_tipo_beneficio = p_id;

    RETURN 'Tipo de beneficio desactivado';
END;
$$;


ALTER FUNCTION public.fn_baja_tipo_beneficio(p_id integer) OWNER TO postgres;

--
-- TOC entry 567 (class 1255 OID 36499)
-- Name: fn_baja_uso_beneficio(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_uso_beneficio(p_id_uso_beneficio integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM uso_beneficios 
        WHERE id_uso_beneficio = p_id_uso_beneficio
    ) THEN
        RETURN 'Registro no existe';
    END IF;

    UPDATE uso_beneficios
    SET activo = FALSE
    WHERE id_uso_beneficio = p_id_uso_beneficio;

    RETURN 'Uso de beneficio desactivado';
END;
$$;


ALTER FUNCTION public.fn_baja_uso_beneficio(p_id_uso_beneficio integer) OWNER TO postgres;

--
-- TOC entry 542 (class 1255 OID 23617)
-- Name: fn_baja_zona(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_baja_zona(p_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM zonas WHERE id_zona = p_id
    ) THEN
        RETURN 'La zona no existe';
    END IF;

    IF EXISTS (
        SELECT 1 FROM zonas 
        WHERE id_zona = p_id AND activo = FALSE
    ) THEN
        RETURN 'La zona ya está inactiva';
    END IF;

    UPDATE zonas
    SET activo = FALSE
    WHERE id_zona = p_id;

    RETURN 'Zona desactivada';
END;
$$;


ALTER FUNCTION public.fn_baja_zona(p_id integer) OWNER TO postgres;

--
-- TOC entry 605 (class 1255 OID 23603)
-- Name: fn_cambiar_permiso(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_cambiar_permiso(p_id_rol integer, p_id_permiso_viejo integer, p_id_permiso_nuevo integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE rol_permiso
    SET id_permiso = p_id_permiso_nuevo
    WHERE id_rol = p_id_rol AND id_permiso = p_id_permiso_viejo;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.fn_cambiar_permiso(p_id_rol integer, p_id_permiso_viejo integer, p_id_permiso_nuevo integer) OWNER TO postgres;

--
-- TOC entry 565 (class 1255 OID 23579)
-- Name: fn_editar_permiso(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_editar_permiso(p_id_permiso integer, p_nombre_permiso character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE permisos 
    SET nombre_permiso = p_nombre_permiso
    WHERE id_permiso = p_id_permiso;

    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.fn_editar_permiso(p_id_permiso integer, p_nombre_permiso character varying) OWNER TO postgres;

--
-- TOC entry 499 (class 1255 OID 23569)
-- Name: fn_editar_rol(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_editar_rol(p_id_rol integer, p_nombre_rol character varying, p_descripcion character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE roles
    SET nombre_rol = p_nombre_rol,
        descripcion = p_descripcion
    WHERE id_rol = p_id_rol;

    -- Retorna true si se encontró y actualizó el registro
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.fn_editar_rol(p_id_rol integer, p_nombre_rol character varying, p_descripcion character varying) OWNER TO postgres;

--
-- TOC entry 570 (class 1255 OID 23600)
-- Name: fn_eliminar_menu_producto(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_eliminar_menu_producto(p_id_menu integer, p_id_producto integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM menu_productos
    WHERE id_menu = p_id_menu
    AND id_producto = p_id_producto;

    IF NOT FOUND THEN
        RETURN 'La relación no existe';
    END IF;

    RETURN 'Producto eliminado del menú';
END;
$$;


ALTER FUNCTION public.fn_eliminar_menu_producto(p_id_menu integer, p_id_producto integer) OWNER TO postgres;

--
-- TOC entry 604 (class 1255 OID 32815)
-- Name: fn_get_grupos_por_paquete(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_get_grupos_por_paquete(p_id_paquete integer) RETURNS TABLE(id_paquete_grupo integer, nombre_grupo character varying, seleccion_obligatoria boolean, cantidad_selecciones integer, esta_activo boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        g.id_paquete_grupo,
        g.nombre_grupo,
        g.seleccion_obligatoria,
        g.cantidad_selecciones,
        g.activo
    FROM paquete_grupos g
    WHERE g.id_paquete = p_id_paquete
    ORDER BY g.id_paquete_grupo ASC;
END;
$$;


ALTER FUNCTION public.fn_get_grupos_por_paquete(p_id_paquete integer) OWNER TO postgres;

--
-- TOC entry 507 (class 1255 OID 24837)
-- Name: fn_get_ingredientes_de_producto(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_get_ingredientes_de_producto(p_id_producto integer) RETURNS TABLE(id_producto integer, nombre_producto character varying, id_ingrediente integer, nombre_ingrediente character varying, tipo_ingrediente public.tipo_ingrediente_enum, es_obligatorio boolean, precio_extra numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id_producto,
        p.nombre_producto,
        i.id_ingrediente,
        i.nombre_ingrediente,
        i.tipo_ingrediente,
        pi.es_obligatorio,
        pi.precio_modificador
    FROM productos p
    JOIN producto_ingrediente pi ON p.id_producto = pi.id_producto
    JOIN ingredientes i ON pi.id_ingrediente = i.id_ingrediente
    WHERE p.id_producto = p_id_producto
    AND pi.activo = TRUE; -- Solo mostramos los ingredientes vinculados actualmente
END;
$$;


ALTER FUNCTION public.fn_get_ingredientes_de_producto(p_id_producto integer) OWNER TO postgres;

--
-- TOC entry 621 (class 1255 OID 35041)
-- Name: fn_get_menu_paquetes_completo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_get_menu_paquetes_completo() RETURNS TABLE(menu_json jsonb)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        jsonb_agg(
            jsonb_build_object(
                'id_paquete', p.id_paquete,
                'nombre', p.nombre_paquete,
                'descripcion', p.descripcion,
                'precio', p.precio_paquete,
                'imagen', p.url_imagen,
                'grupos', (
                    SELECT jsonb_agg(
                        jsonb_build_object(
                            'id_grupo', g.id_paquete_grupo,
                            'nombre_grupo', g.nombre_grupo,
                            'obligatorio', g.seleccion_obligatoria,
                            'cantidad', g.cantidad_selecciones,
                            'opciones', (
                                SELECT jsonb_agg(
                                    jsonb_build_object(
                                        'id_producto', prod.id_producto,
                                        'nombre_producto', prod.nombre_producto,
                                        'precio_extra', pgi.precio_adicional,
                                        'imagen_prod', prod.url_imagen
                                    )
                                )
                                FROM paquete_grupo_productos pgi
                                JOIN productos prod ON pgi.id_producto = prod.id_producto
                                WHERE pgi.id_paquete_grupo = g.id_paquete_grupo
                            )
                        )
                    )
                    FROM paquete_grupos g
                    WHERE g.id_paquete = p.id_paquete AND g.activo = TRUE
                )
            )
        )
    FROM paquetes p
    WHERE p.activo = TRUE;
END;
$$;


ALTER FUNCTION public.fn_get_menu_paquetes_completo() OWNER TO postgres;

--
-- TOC entry 566 (class 1255 OID 23684)
-- Name: fn_get_productos_por_menu(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_get_productos_por_menu(p_id_menu integer) RETURNS TABLE(id_menu integer, nombre_menu character varying, id_producto integer, nombre_producto character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.id_menu,
        v.nombre_menu,
        v.id_producto,
        v.nombre_producto
    FROM v_menu_productos_activos v
    WHERE v.id_menu = p_id_menu;
END;
$$;


ALTER FUNCTION public.fn_get_productos_por_menu(p_id_menu integer) OWNER TO postgres;

--
-- TOC entry 513 (class 1255 OID 23602)
-- Name: fn_quitar_permiso(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_quitar_permiso(p_id_rol integer, p_id_permiso integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM rol_permiso 
    WHERE id_rol = p_id_rol AND id_permiso = p_id_permiso;
    RETURN FOUND;
END;
$$;


ALTER FUNCTION public.fn_quitar_permiso(p_id_rol integer, p_id_permiso integer) OWNER TO postgres;

--
-- TOC entry 486 (class 1255 OID 17201)
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- TOC entry 554 (class 1255 OID 17280)
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- TOC entry 617 (class 1255 OID 17213)
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- TOC entry 638 (class 1255 OID 17163)
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- TOC entry 519 (class 1255 OID 17158)
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- TOC entry 582 (class 1255 OID 17209)
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- TOC entry 626 (class 1255 OID 36393)
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL AND ppt.tablename NOT LIKE '% %'),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  -- Count raw slot entries before apply_rls/subscription filter
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  -- Apply RLS and filter as before
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  -- Real rows with slot count attached
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  -- Sentinel row: always returned when no real rows exist so Elixir can
  -- always read slot_changes_count. Identified by wal IS NULL.
  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- TOC entry 491 (class 1255 OID 17157)
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- TOC entry 587 (class 1255 OID 17279)
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- TOC entry 495 (class 1255 OID 17155)
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- TOC entry 593 (class 1255 OID 17190)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- TOC entry 501 (class 1255 OID 17273)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- TOC entry 555 (class 1255 OID 32817)
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- TOC entry 627 (class 1255 OID 32816)
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

--
-- TOC entry 660 (class 1255 OID 17367)
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- TOC entry 563 (class 1255 OID 17423)
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- TOC entry 615 (class 1255 OID 17342)
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 568 (class 1255 OID 17341)
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 592 (class 1255 OID 17340)
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- TOC entry 547 (class 1255 OID 17480)
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- TOC entry 485 (class 1255 OID 17354)
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- TOC entry 584 (class 1255 OID 17406)
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- TOC entry 628 (class 1255 OID 17481)
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- TOC entry 571 (class 1255 OID 17422)
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- TOC entry 632 (class 1255 OID 17487)
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- TOC entry 651 (class 1255 OID 17356)
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- TOC entry 676 (class 1255 OID 17485)
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- TOC entry 531 (class 1255 OID 17484)
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- TOC entry 606 (class 1255 OID 17357)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 356 (class 1259 OID 16529)
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 376 (class 1259 OID 17078)
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 370 (class 1259 OID 16883)
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 361 (class 1259 OID 16681)
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 361
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 355 (class 1259 OID 16522)
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 365 (class 1259 OID 16770)
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 364 (class 1259 OID 16758)
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 363 (class 1259 OID 16745)
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 363
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 373 (class 1259 OID 16995)
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- TOC entry 375 (class 1259 OID 17068)
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 372 (class 1259 OID 16965)
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- TOC entry 374 (class 1259 OID 17028)
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- TOC entry 371 (class 1259 OID 16933)
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 354 (class 1259 OID 16511)
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 353 (class 1259 OID 16510)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 353
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 368 (class 1259 OID 16812)
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 369 (class 1259 OID 16830)
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 357 (class 1259 OID 16537)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 362 (class 1259 OID 16711)
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 362
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 367 (class 1259 OID 16797)
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 366 (class 1259 OID 16788)
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 366
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 352 (class 1259 OID 16499)
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 352
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 414 (class 1259 OID 21046)
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- TOC entry 413 (class 1259 OID 21023)
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- TOC entry 406 (class 1259 OID 20965)
-- Name: categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria (
    id_categoria integer NOT NULL,
    nombre_cat character varying(100) NOT NULL,
    descripcion_cat text,
    activo boolean DEFAULT true
);


ALTER TABLE public.categoria OWNER TO postgres;

--
-- TOC entry 405 (class 1259 OID 20964)
-- Name: categoria_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categoria_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_id_categoria_seq OWNER TO postgres;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 405
-- Name: categoria_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_id_categoria_seq OWNED BY public.categoria.id_categoria;


--
-- TOC entry 404 (class 1259 OID 19832)
-- Name: cliente_beneficio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente_beneficio (
    id_cliente_beneficio integer NOT NULL,
    id_cliente integer NOT NULL,
    id_tipo_beneficio integer NOT NULL,
    cantidad_disponible integer DEFAULT 0,
    cantidad_usada integer DEFAULT 0,
    fecha_inicio date NOT NULL,
    fecha_fin date,
    dias_aplica character varying(50),
    activo boolean DEFAULT true
);


ALTER TABLE public.cliente_beneficio OWNER TO postgres;

--
-- TOC entry 403 (class 1259 OID 19831)
-- Name: cliente_beneficio_id_cliente_beneficio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_beneficio_id_cliente_beneficio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_beneficio_id_cliente_beneficio_seq OWNER TO postgres;

--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 403
-- Name: cliente_beneficio_id_cliente_beneficio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_beneficio_id_cliente_beneficio_seq OWNED BY public.cliente_beneficio.id_cliente_beneficio;


--
-- TOC entry 400 (class 1259 OID 19802)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id_cliente integer NOT NULL,
    nombre character varying(100),
    email character varying(100),
    telefono character varying(20),
    codigo_rfid character varying(100),
    activo boolean DEFAULT true,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- TOC entry 399 (class 1259 OID 19801)
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_cliente_seq OWNER TO postgres;

--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 399
-- Name: clientes_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_cliente_seq OWNED BY public.clientes.id_cliente;


--
-- TOC entry 416 (class 1259 OID 22182)
-- Name: ingredientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredientes (
    id_ingrediente integer NOT NULL,
    nombre_ingrediente character varying(100) NOT NULL,
    tipo_ingrediente public.tipo_ingrediente_enum,
    precio_adicional numeric(10,2) DEFAULT 0,
    activo boolean DEFAULT true
);


ALTER TABLE public.ingredientes OWNER TO postgres;

--
-- TOC entry 415 (class 1259 OID 22181)
-- Name: ingredientes_id_ingrediente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredientes_id_ingrediente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredientes_id_ingrediente_seq OWNER TO postgres;

--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 415
-- Name: ingredientes_id_ingrediente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredientes_id_ingrediente_seq OWNED BY public.ingredientes.id_ingrediente;


--
-- TOC entry 469 (class 1259 OID 41697)
-- Name: inventario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario (
    id_inventario integer NOT NULL,
    id_ingrediente integer NOT NULL,
    cantidad_actual numeric(10,2) DEFAULT 0,
    cantidad_minima numeric(10,2) DEFAULT 0,
    unidad character varying(20),
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true
);


ALTER TABLE public.inventario OWNER TO postgres;

--
-- TOC entry 468 (class 1259 OID 41696)
-- Name: inventario_id_inventario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_id_inventario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_id_inventario_seq OWNER TO postgres;

--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 468
-- Name: inventario_id_inventario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_id_inventario_seq OWNED BY public.inventario.id_inventario;


--
-- TOC entry 472 (class 1259 OID 41720)
-- Name: inventario_movimientos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventario_movimientos (
    id_movimiento integer NOT NULL,
    id_inventario integer,
    tipo_movimiento character varying(20),
    cantidad numeric(10,2),
    motivo text,
    fecha_movimiento timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id_usuario integer,
    activo boolean DEFAULT true
);


ALTER TABLE public.inventario_movimientos OWNER TO postgres;

--
-- TOC entry 471 (class 1259 OID 41719)
-- Name: inventario_movimientos_id_movimiento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventario_movimientos_id_movimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventario_movimientos_id_movimiento_seq OWNER TO postgres;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 471
-- Name: inventario_movimientos_id_movimiento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventario_movimientos_id_movimiento_seq OWNED BY public.inventario_movimientos.id_movimiento;


--
-- TOC entry 422 (class 1259 OID 23378)
-- Name: menu_productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_productos (
    id_menu integer NOT NULL,
    id_producto integer NOT NULL
);


ALTER TABLE public.menu_productos OWNER TO postgres;

--
-- TOC entry 421 (class 1259 OID 23369)
-- Name: menus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menus (
    id_menu integer NOT NULL,
    nombre_menu character varying(100) NOT NULL,
    descripcion text,
    hora_inicio time without time zone NOT NULL,
    hora_fin time without time zone NOT NULL,
    dias_semana character varying(100),
    activo boolean DEFAULT true,
    fecha_inicio date,
    fecha_fin date
);


ALTER TABLE public.menus OWNER TO postgres;

--
-- TOC entry 420 (class 1259 OID 23368)
-- Name: menus_id_menu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menus_id_menu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menus_id_menu_seq OWNER TO postgres;

--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 420
-- Name: menus_id_menu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menus_id_menu_seq OWNED BY public.menus.id_menu;


--
-- TOC entry 456 (class 1259 OID 36230)
-- Name: orden_detalle_modificadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_detalle_modificadores (
    id_detalle_modificador integer NOT NULL,
    id_orden_detalle integer NOT NULL,
    id_ingrediente integer NOT NULL,
    accion public.accion_modificador_enum DEFAULT 'agregar'::public.accion_modificador_enum,
    precio_modificador numeric(10,2) DEFAULT 0.00
);


ALTER TABLE public.orden_detalle_modificadores OWNER TO postgres;

--
-- TOC entry 455 (class 1259 OID 36229)
-- Name: orden_detalle_modificadores_id_detalle_modificador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_detalle_modificadores_id_detalle_modificador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_detalle_modificadores_id_detalle_modificador_seq OWNER TO postgres;

--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 455
-- Name: orden_detalle_modificadores_id_detalle_modificador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_detalle_modificadores_id_detalle_modificador_seq OWNED BY public.orden_detalle_modificadores.id_detalle_modificador;


--
-- TOC entry 452 (class 1259 OID 36174)
-- Name: orden_detalles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_detalles (
    id_orden_detalle integer NOT NULL,
    id_orden integer NOT NULL,
    id_producto integer,
    id_paquete integer,
    cantidad integer DEFAULT 1 NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    descuento_aplicado numeric(10,2) DEFAULT 0.00,
    subtotal numeric(10,2) NOT NULL,
    id_promocion integer,
    estado_preparacion public.estado_preparacion_enum DEFAULT 'pendiente'::public.estado_preparacion_enum,
    id_zona integer,
    notas_especiales text,
    CONSTRAINT chk_producto_o_paquete CHECK (((id_producto IS NOT NULL) OR (id_paquete IS NOT NULL)))
);


ALTER TABLE public.orden_detalles OWNER TO postgres;

--
-- TOC entry 451 (class 1259 OID 36173)
-- Name: orden_detalles_id_orden_detalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_detalles_id_orden_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_detalles_id_orden_detalle_seq OWNER TO postgres;

--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 451
-- Name: orden_detalles_id_orden_detalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_detalles_id_orden_detalle_seq OWNED BY public.orden_detalles.id_orden_detalle;


--
-- TOC entry 461 (class 1259 OID 36452)
-- Name: orden_pagos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_pagos (
    id_pago integer NOT NULL,
    id_orden integer,
    metodo_pago public.metodo_pago_enum NOT NULL,
    monto_pagado numeric(10,2) NOT NULL,
    referencia character varying(100),
    fecha_pago timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id_usuario integer,
    activo boolean DEFAULT true
);


ALTER TABLE public.orden_pagos OWNER TO postgres;

--
-- TOC entry 460 (class 1259 OID 36451)
-- Name: orden_pagos_id_pago_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_pagos_id_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_pagos_id_pago_seq OWNER TO postgres;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 460
-- Name: orden_pagos_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_pagos_id_pago_seq OWNED BY public.orden_pagos.id_pago;


--
-- TOC entry 459 (class 1259 OID 36255)
-- Name: orden_paquete_selecciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_paquete_selecciones (
    id_seleccion integer NOT NULL,
    id_orden_detalle integer NOT NULL,
    id_paquete_grupo integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad integer DEFAULT 1,
    CONSTRAINT chk_ops_cantidad CHECK ((cantidad > 0))
);


ALTER TABLE public.orden_paquete_selecciones OWNER TO postgres;

--
-- TOC entry 458 (class 1259 OID 36254)
-- Name: orden_paquete_selecciones_id_seleccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_paquete_selecciones_id_seleccion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_paquete_selecciones_id_seleccion_seq OWNER TO postgres;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 458
-- Name: orden_paquete_selecciones_id_seleccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_paquete_selecciones_id_seleccion_seq OWNED BY public.orden_paquete_selecciones.id_seleccion;


--
-- TOC entry 430 (class 1259 OID 23498)
-- Name: ordenes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordenes (
    id_orden integer NOT NULL,
    numero_orden character varying(20) NOT NULL,
    id_usuario integer,
    id_cliente integer,
    tipo_orden public.tipo_orden_enum DEFAULT 'local'::public.tipo_orden_enum,
    mesa_numero character varying(20),
    subtotal numeric(10,2) NOT NULL,
    descuento numeric(10,2) DEFAULT 0.00,
    impuestos numeric(10,2) DEFAULT 0.00,
    total numeric(10,2) NOT NULL,
    estado_orden public.estado_orden_enum DEFAULT 'pendiente'::public.estado_orden_enum,
    estado_pago public.estado_pago_enum DEFAULT 'pendiente'::public.estado_pago_enum,
    metodo_pago public.metodo_pago_enum,
    notas_orden text,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega timestamp without time zone
);


ALTER TABLE public.ordenes OWNER TO postgres;

--
-- TOC entry 429 (class 1259 OID 23497)
-- Name: ordenes_id_orden_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ordenes_id_orden_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ordenes_id_orden_seq OWNER TO postgres;

--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 429
-- Name: ordenes_id_orden_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ordenes_id_orden_seq OWNED BY public.ordenes.id_orden;


--
-- TOC entry 427 (class 1259 OID 23437)
-- Name: paquete_grupo_productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paquete_grupo_productos (
    id_paquete_grupo integer NOT NULL,
    id_producto integer NOT NULL,
    precio_adicional numeric(10,2) DEFAULT 0.00
);


ALTER TABLE public.paquete_grupo_productos OWNER TO postgres;

--
-- TOC entry 426 (class 1259 OID 23424)
-- Name: paquete_grupos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paquete_grupos (
    id_paquete_grupo integer NOT NULL,
    id_paquete integer NOT NULL,
    nombre_grupo character varying(100),
    seleccion_obligatoria boolean DEFAULT true,
    cantidad_selecciones integer DEFAULT 1,
    activo boolean DEFAULT true
);


ALTER TABLE public.paquete_grupos OWNER TO postgres;

--
-- TOC entry 425 (class 1259 OID 23423)
-- Name: paquete_grupos_id_paquete_grupo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paquete_grupos_id_paquete_grupo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paquete_grupos_id_paquete_grupo_seq OWNER TO postgres;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 425
-- Name: paquete_grupos_id_paquete_grupo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paquete_grupos_id_paquete_grupo_seq OWNED BY public.paquete_grupos.id_paquete_grupo;


--
-- TOC entry 424 (class 1259 OID 23403)
-- Name: paquetes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paquetes (
    id_paquete integer NOT NULL,
    nombre_paquete character varying(150) NOT NULL,
    descripcion text,
    precio_paquete numeric(10,2) NOT NULL,
    activo boolean DEFAULT true,
    es_temporal boolean DEFAULT false,
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    dias_disponibles character varying(100),
    url_imagen text
);


ALTER TABLE public.paquetes OWNER TO postgres;

--
-- TOC entry 423 (class 1259 OID 23402)
-- Name: paquetes_id_paquete_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paquetes_id_paquete_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.paquetes_id_paquete_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 423
-- Name: paquetes_id_paquete_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paquetes_id_paquete_seq OWNED BY public.paquetes.id_paquete;


--
-- TOC entry 395 (class 1259 OID 17531)
-- Name: permisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permisos (
    id_permiso integer NOT NULL,
    nombre_permiso character varying(50) NOT NULL
);


ALTER TABLE public.permisos OWNER TO postgres;

--
-- TOC entry 394 (class 1259 OID 17530)
-- Name: permisos_id_permiso_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permisos_id_permiso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permisos_id_permiso_seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 394
-- Name: permisos_id_permiso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permisos_id_permiso_seq OWNED BY public.permisos.id_permiso;


--
-- TOC entry 418 (class 1259 OID 22191)
-- Name: producto_ingrediente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto_ingrediente (
    id_producto_ingrediente integer NOT NULL,
    id_producto integer NOT NULL,
    id_ingrediente integer NOT NULL,
    es_obligatorio boolean DEFAULT false,
    precio_modificador numeric(10,2) DEFAULT 0.0,
    activo boolean DEFAULT true
);


ALTER TABLE public.producto_ingrediente OWNER TO postgres;

--
-- TOC entry 417 (class 1259 OID 22190)
-- Name: producto_ingrediente_id_producto_ingrediente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_ingrediente_id_producto_ingrediente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_ingrediente_id_producto_ingrediente_seq OWNER TO postgres;

--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 417
-- Name: producto_ingrediente_id_producto_ingrediente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_ingrediente_id_producto_ingrediente_seq OWNED BY public.producto_ingrediente.id_producto_ingrediente;


--
-- TOC entry 412 (class 1259 OID 20996)
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    id_producto integer NOT NULL,
    nombre_producto character varying(150) NOT NULL,
    descripcion_pro text,
    precio_base numeric(10,2) NOT NULL,
    id_zona integer NOT NULL,
    id_categoria integer NOT NULL,
    disponibilidad boolean DEFAULT true,
    url_imagen text
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- TOC entry 411 (class 1259 OID 20995)
-- Name: productos_id_producto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.productos_id_producto_seq OWNER TO postgres;

--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 411
-- Name: productos_id_producto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_id_producto_seq OWNED BY public.productos.id_producto;


--
-- TOC entry 448 (class 1259 OID 31682)
-- Name: promocion_clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promocion_clientes (
    id_promocion integer NOT NULL,
    id_cliente integer NOT NULL
);


ALTER TABLE public.promocion_clientes OWNER TO postgres;

--
-- TOC entry 446 (class 1259 OID 31654)
-- Name: promocion_paquetes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promocion_paquetes (
    id_promocion integer NOT NULL,
    id_paquete integer NOT NULL
);


ALTER TABLE public.promocion_paquetes OWNER TO postgres;

--
-- TOC entry 444 (class 1259 OID 31632)
-- Name: promocion_productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promocion_productos (
    id_promocion integer NOT NULL,
    id_producto integer NOT NULL
);


ALTER TABLE public.promocion_productos OWNER TO postgres;

--
-- TOC entry 443 (class 1259 OID 31612)
-- Name: promociones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promociones (
    id_promocion integer NOT NULL,
    nombre_promocion character varying(100) NOT NULL,
    descripcion text,
    tipo_promocion public.tipo_promocion_enum NOT NULL,
    valor_descuento numeric(10,2),
    es_temporal boolean DEFAULT false,
    fecha_inicio timestamp without time zone,
    fecha_fin timestamp without time zone,
    hora_inicio time without time zone,
    hora_fin time without time zone,
    dias_aplicables text[],
    es_permanente boolean DEFAULT false,
    solo_clientes_registrados boolean DEFAULT false,
    activo boolean DEFAULT true,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.promociones OWNER TO postgres;

--
-- TOC entry 442 (class 1259 OID 31611)
-- Name: promociones_id_promocion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promociones_id_promocion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promociones_id_promocion_seq OWNER TO postgres;

--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 442
-- Name: promociones_id_promocion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promociones_id_promocion_seq OWNED BY public.promociones.id_promocion;


--
-- TOC entry 396 (class 1259 OID 17537)
-- Name: rol_permiso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol_permiso (
    id_rol integer NOT NULL,
    id_permiso integer NOT NULL
);


ALTER TABLE public.rol_permiso OWNER TO postgres;

--
-- TOC entry 393 (class 1259 OID 17524)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id_rol integer NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    descripcion character varying(150)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 392 (class 1259 OID 17523)
-- Name: roles_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_rol_seq OWNER TO postgres;

--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 392
-- Name: roles_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_rol_seq OWNED BY public.roles.id_rol;


--
-- TOC entry 402 (class 1259 OID 19819)
-- Name: tipo_beneficio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_beneficio (
    id_tipo_beneficio integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    activo boolean DEFAULT true
);


ALTER TABLE public.tipo_beneficio OWNER TO postgres;

--
-- TOC entry 401 (class 1259 OID 19818)
-- Name: tipo_beneficio_id_tipo_beneficio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_beneficio_id_tipo_beneficio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_beneficio_id_tipo_beneficio_seq OWNER TO postgres;

--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 401
-- Name: tipo_beneficio_id_tipo_beneficio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_beneficio_id_tipo_beneficio_seq OWNED BY public.tipo_beneficio.id_tipo_beneficio;


--
-- TOC entry 464 (class 1259 OID 36479)
-- Name: uso_beneficios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uso_beneficios (
    id_uso_beneficio integer NOT NULL,
    id_cliente_beneficio integer,
    id_orden integer,
    cantidad_usada integer DEFAULT 1,
    fecha_uso timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true
);


ALTER TABLE public.uso_beneficios OWNER TO postgres;

--
-- TOC entry 463 (class 1259 OID 36478)
-- Name: uso_beneficios_id_uso_beneficio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uso_beneficios_id_uso_beneficio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.uso_beneficios_id_uso_beneficio_seq OWNER TO postgres;

--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 463
-- Name: uso_beneficios_id_uso_beneficio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uso_beneficios_id_uso_beneficio_seq OWNED BY public.uso_beneficios.id_uso_beneficio;


--
-- TOC entry 398 (class 1259 OID 19790)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    nombre_usuario character varying(50),
    contra text,
    id_rol integer
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 397 (class 1259 OID 19789)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 397
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- TOC entry 407 (class 1259 OID 20977)
-- Name: v_categoria; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_categoria AS
 SELECT id_categoria,
    nombre_cat,
    descripcion_cat
   FROM public.categoria
  WHERE (activo = true);


ALTER VIEW public.v_categoria OWNER TO postgres;

--
-- TOC entry 450 (class 1259 OID 35055)
-- Name: v_cliente_beneficio; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_cliente_beneficio AS
 SELECT cb.id_cliente_beneficio,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    tb.id_tipo_beneficio,
    tb.nombre AS nombre_beneficio,
    cb.cantidad_disponible,
    cb.cantidad_usada,
    cb.fecha_inicio,
    cb.fecha_fin,
    cb.dias_aplica,
    cb.activo
   FROM ((public.cliente_beneficio cb
     JOIN public.clientes c ON ((cb.id_cliente = c.id_cliente)))
     JOIN public.tipo_beneficio tb ON ((cb.id_tipo_beneficio = tb.id_tipo_beneficio)));


ALTER VIEW public.v_cliente_beneficio OWNER TO postgres;

--
-- TOC entry 437 (class 1259 OID 23690)
-- Name: v_clientes_activos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_clientes_activos AS
 SELECT id_cliente,
    nombre,
    email,
    telefono,
    codigo_rfid,
    activo
   FROM public.clientes;


ALTER VIEW public.v_clientes_activos OWNER TO postgres;

--
-- TOC entry 434 (class 1259 OID 23604)
-- Name: v_ingredientes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_ingredientes AS
 SELECT id_ingrediente AS id,
    nombre_ingrediente AS ingrediente,
    tipo_ingrediente AS tipo,
    precio_adicional AS precio,
        CASE
            WHEN activo THEN 'Disponible'::text
            ELSE 'No disponible'::text
        END AS estado
   FROM public.ingredientes;


ALTER VIEW public.v_ingredientes OWNER TO postgres;

--
-- TOC entry 470 (class 1259 OID 41712)
-- Name: v_inventario; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_inventario AS
 SELECT i.id_inventario,
    ing.id_ingrediente,
    ing.nombre_ingrediente,
    i.cantidad_actual,
    i.cantidad_minima,
    i.unidad,
    i.fecha_actualizacion,
    i.activo,
        CASE
            WHEN (i.cantidad_actual <= i.cantidad_minima) THEN 'BAJO'::text
            ELSE 'OK'::text
        END AS estado_stock
   FROM (public.inventario i
     JOIN public.ingredientes ing ON ((i.id_ingrediente = ing.id_ingrediente)));


ALTER VIEW public.v_inventario OWNER TO postgres;

--
-- TOC entry 473 (class 1259 OID 41736)
-- Name: v_inventario_movimientos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_inventario_movimientos AS
 SELECT im.id_movimiento,
    i.id_inventario,
    ing.id_ingrediente,
    ing.nombre_ingrediente,
    im.tipo_movimiento,
    im.cantidad,
    im.motivo,
    u.id_usuario,
    u.nombre_usuario,
    im.fecha_movimiento,
    im.activo
   FROM (((public.inventario_movimientos im
     JOIN public.inventario i ON ((im.id_inventario = i.id_inventario)))
     JOIN public.ingredientes ing ON ((i.id_ingrediente = ing.id_ingrediente)))
     LEFT JOIN public.usuarios u ON ((im.id_usuario = u.id_usuario)));


ALTER VIEW public.v_inventario_movimientos OWNER TO postgres;

--
-- TOC entry 436 (class 1259 OID 23660)
-- Name: v_menu_productos_activos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_menu_productos_activos AS
 SELECT m.id_menu,
    m.nombre_menu,
    p.id_producto,
    p.nombre_producto
   FROM ((public.menus m
     JOIN public.menu_productos mp ON ((m.id_menu = mp.id_menu)))
     JOIN public.productos p ON ((mp.id_producto = p.id_producto)))
  WHERE ((m.activo = true) AND (p.disponibilidad = true));


ALTER VIEW public.v_menu_productos_activos OWNER TO postgres;

--
-- TOC entry 465 (class 1259 OID 36507)
-- Name: v_orden_completa; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_orden_completa AS
 SELECT o.id_orden,
    o.numero_orden,
    u.nombre_usuario AS usuario,
    c.nombre AS cliente,
    od.id_orden_detalle,
    p.nombre_producto,
    pa.nombre_paquete,
    od.cantidad,
    od.precio_unitario,
    od.subtotal,
    od.estado_preparacion,
    i.nombre_ingrediente,
    o.total,
    o.estado_orden,
    o.estado_pago,
    o.fecha_creacion
   FROM (((((((public.ordenes o
     LEFT JOIN public.usuarios u ON ((o.id_usuario = u.id_usuario)))
     LEFT JOIN public.clientes c ON ((o.id_cliente = c.id_cliente)))
     LEFT JOIN public.orden_detalles od ON ((o.id_orden = od.id_orden)))
     LEFT JOIN public.productos p ON ((od.id_producto = p.id_producto)))
     LEFT JOIN public.paquetes pa ON ((od.id_paquete = pa.id_paquete)))
     LEFT JOIN public.producto_ingrediente pi ON ((p.id_producto = pi.id_producto)))
     LEFT JOIN public.ingredientes i ON ((pi.id_ingrediente = i.id_ingrediente)));


ALTER VIEW public.v_orden_completa OWNER TO postgres;

--
-- TOC entry 409 (class 1259 OID 20982)
-- Name: zonas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zonas (
    id_zona integer NOT NULL,
    nombre_zona character varying(100) NOT NULL,
    descripcion_zona text,
    activo boolean DEFAULT true
);


ALTER TABLE public.zonas OWNER TO postgres;

--
-- TOC entry 453 (class 1259 OID 36211)
-- Name: v_orden_detalles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_orden_detalles AS
 SELECT od.id_orden_detalle,
    o.id_orden,
    o.numero_orden,
    p.id_producto,
    p.nombre_producto,
    pa.id_paquete,
    pa.nombre_paquete,
    od.cantidad,
    od.precio_unitario,
    od.descuento_aplicado,
    od.subtotal,
    pr.id_promocion,
    pr.nombre_promocion,
    od.estado_preparacion,
    z.id_zona,
    z.nombre_zona,
    od.notas_especiales
   FROM (((((public.orden_detalles od
     JOIN public.ordenes o ON ((od.id_orden = o.id_orden)))
     LEFT JOIN public.productos p ON ((od.id_producto = p.id_producto)))
     LEFT JOIN public.paquetes pa ON ((od.id_paquete = pa.id_paquete)))
     LEFT JOIN public.promociones pr ON ((od.id_promocion = pr.id_promocion)))
     LEFT JOIN public.zonas z ON ((od.id_zona = z.id_zona)));


ALTER VIEW public.v_orden_detalles OWNER TO postgres;

--
-- TOC entry 454 (class 1259 OID 36216)
-- Name: v_orden_detalles_cocina; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_orden_detalles_cocina AS
 SELECT id_orden_detalle,
    id_orden,
    numero_orden,
    id_producto,
    nombre_producto,
    id_paquete,
    nombre_paquete,
    cantidad,
    precio_unitario,
    descuento_aplicado,
    subtotal,
    id_promocion,
    nombre_promocion,
    estado_preparacion,
    id_zona,
    nombre_zona,
    notas_especiales
   FROM public.v_orden_detalles
  WHERE (estado_preparacion = ANY (ARRAY['pendiente'::public.estado_preparacion_enum, 'en_proceso'::public.estado_preparacion_enum]));


ALTER VIEW public.v_orden_detalles_cocina OWNER TO postgres;

--
-- TOC entry 457 (class 1259 OID 36248)
-- Name: v_orden_modificadores; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_orden_modificadores AS
 SELECT odm.id_detalle_modificador,
    od.id_orden_detalle,
    o.numero_orden,
    p.nombre_producto,
    i.id_ingrediente,
    i.nombre_ingrediente,
    odm.accion,
    odm.precio_modificador
   FROM ((((public.orden_detalle_modificadores odm
     JOIN public.orden_detalles od ON ((odm.id_orden_detalle = od.id_orden_detalle)))
     JOIN public.ordenes o ON ((od.id_orden = o.id_orden)))
     LEFT JOIN public.productos p ON ((od.id_producto = p.id_producto)))
     JOIN public.ingredientes i ON ((odm.id_ingrediente = i.id_ingrediente)));


ALTER VIEW public.v_orden_modificadores OWNER TO postgres;

--
-- TOC entry 462 (class 1259 OID 36470)
-- Name: v_orden_pagos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_orden_pagos AS
 SELECT op.id_pago,
    op.id_orden,
    o.numero_orden,
    op.metodo_pago,
    op.monto_pagado,
    op.referencia,
    op.fecha_pago,
    op.id_usuario,
    u.nombre_usuario,
    op.activo
   FROM ((public.orden_pagos op
     LEFT JOIN public.ordenes o ON ((op.id_orden = o.id_orden)))
     LEFT JOIN public.usuarios u ON ((op.id_usuario = u.id_usuario)));


ALTER VIEW public.v_orden_pagos OWNER TO postgres;

--
-- TOC entry 467 (class 1259 OID 36529)
-- Name: v_orden_paquete_selecciones; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_orden_paquete_selecciones AS
 SELECT ops.id_seleccion,
    od.id_orden_detalle,
    o.id_orden,
    o.numero_orden,
    od.id_paquete,
    pa.nombre_paquete,
    pg.id_paquete_grupo,
    pg.nombre_grupo,
    p.id_producto,
    p.nombre_producto,
    ops.cantidad
   FROM (((((public.orden_paquete_selecciones ops
     JOIN public.orden_detalles od ON ((ops.id_orden_detalle = od.id_orden_detalle)))
     JOIN public.ordenes o ON ((od.id_orden = o.id_orden)))
     LEFT JOIN public.paquetes pa ON ((od.id_paquete = pa.id_paquete)))
     JOIN public.paquete_grupos pg ON ((ops.id_paquete_grupo = pg.id_paquete_grupo)))
     JOIN public.productos p ON ((ops.id_producto = p.id_producto)));


ALTER VIEW public.v_orden_paquete_selecciones OWNER TO postgres;

--
-- TOC entry 439 (class 1259 OID 31586)
-- Name: v_ordenes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_ordenes AS
 SELECT o.id_orden,
    o.numero_orden,
    u.nombre_usuario AS usuario,
    c.nombre AS cliente,
    o.tipo_orden,
    o.mesa_numero,
    o.subtotal,
    o.descuento,
    o.impuestos,
    o.total,
    o.estado_orden,
    o.estado_pago,
    o.metodo_pago,
    o.notas_orden,
    o.fecha_creacion,
    o.fecha_actualizacion,
    o.fecha_entrega
   FROM ((public.ordenes o
     LEFT JOIN public.usuarios u ON ((o.id_usuario = u.id_usuario)))
     LEFT JOIN public.clientes c ON ((o.id_cliente = c.id_cliente)));


ALTER VIEW public.v_ordenes OWNER TO postgres;

--
-- TOC entry 440 (class 1259 OID 31591)
-- Name: v_ordenes_cocina; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_ordenes_cocina AS
 SELECT id_orden,
    numero_orden,
    tipo_orden,
    mesa_numero,
    estado_orden,
    fecha_creacion
   FROM public.ordenes
  WHERE (estado_orden = ANY (ARRAY['pendiente'::public.estado_orden_enum, 'en_preparacion'::public.estado_orden_enum]));


ALTER VIEW public.v_ordenes_cocina OWNER TO postgres;

--
-- TOC entry 441 (class 1259 OID 31595)
-- Name: v_ordenes_pendientes_pago; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_ordenes_pendientes_pago AS
 SELECT id_orden,
    numero_orden,
    total,
    estado_pago
   FROM public.ordenes
  WHERE (estado_pago = 'pendiente'::public.estado_pago_enum);


ALTER VIEW public.v_ordenes_pendientes_pago OWNER TO postgres;

--
-- TOC entry 428 (class 1259 OID 23453)
-- Name: v_paquete_detalle; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_paquete_detalle AS
 SELECT pa.nombre_paquete,
    pg.nombre_grupo,
    p.nombre_producto,
    pgp.precio_adicional
   FROM (((public.paquete_grupo_productos pgp
     JOIN public.paquete_grupos pg ON ((pgp.id_paquete_grupo = pg.id_paquete_grupo)))
     JOIN public.paquetes pa ON ((pg.id_paquete = pa.id_paquete)))
     JOIN public.productos p ON ((pgp.id_producto = p.id_producto)));


ALTER VIEW public.v_paquete_detalle OWNER TO postgres;

--
-- TOC entry 476 (class 1259 OID 41905)
-- Name: v_paquetes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_paquetes AS
 SELECT id_paquete AS id,
    nombre_paquete AS paquete,
    COALESCE(descripcion, 'Sin descripción'::text) AS descripcion,
    precio_paquete AS precio,
        CASE
            WHEN es_temporal THEN 'Temporal'::text
            ELSE 'Fijo'::text
        END AS tipo,
    dias_disponibles,
    activo,
    url_imagen
   FROM public.paquetes;


ALTER VIEW public.v_paquetes OWNER TO postgres;

--
-- TOC entry 432 (class 1259 OID 23586)
-- Name: v_permisos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_permisos AS
 SELECT id_permiso,
    nombre_permiso
   FROM public.permisos;


ALTER VIEW public.v_permisos OWNER TO postgres;

--
-- TOC entry 419 (class 1259 OID 22210)
-- Name: v_producto_ingrediente; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_producto_ingrediente AS
 SELECT pi.id_producto_ingrediente,
    p.id_producto,
    p.nombre_producto,
    i.id_ingrediente,
    i.nombre_ingrediente,
    pi.es_obligatorio,
    pi.precio_modificador,
    pi.activo
   FROM ((public.producto_ingrediente pi
     JOIN public.productos p ON ((pi.id_producto = p.id_producto)))
     JOIN public.ingredientes i ON ((pi.id_ingrediente = i.id_ingrediente)));


ALTER VIEW public.v_producto_ingrediente OWNER TO postgres;

--
-- TOC entry 477 (class 1259 OID 41909)
-- Name: v_productos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_productos AS
 SELECT p.id_producto,
    p.nombre_producto,
    p.descripcion_pro,
    p.precio_base,
    c.nombre_cat AS categoria,
    z.nombre_zona AS zona,
    p.disponibilidad,
    p.url_imagen
   FROM ((public.productos p
     JOIN public.categoria c ON ((p.id_categoria = c.id_categoria)))
     JOIN public.zonas z ON ((p.id_zona = z.id_zona)));


ALTER VIEW public.v_productos OWNER TO postgres;

--
-- TOC entry 449 (class 1259 OID 31697)
-- Name: v_promocion_clientes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_promocion_clientes AS
 SELECT pr.id_promocion,
    pr.nombre_promocion,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    pr.activo AS promocion_activa
   FROM ((public.promocion_clientes pc
     JOIN public.promociones pr ON ((pc.id_promocion = pr.id_promocion)))
     JOIN public.clientes c ON ((pc.id_cliente = c.id_cliente)));


ALTER VIEW public.v_promocion_clientes OWNER TO postgres;

--
-- TOC entry 447 (class 1259 OID 31669)
-- Name: v_promocion_paquetes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_promocion_paquetes AS
 SELECT pr.id_promocion,
    pr.nombre_promocion,
    pa.id_paquete,
    pa.nombre_paquete
   FROM ((public.promocion_paquetes pp
     JOIN public.promociones pr ON ((pp.id_promocion = pr.id_promocion)))
     JOIN public.paquetes pa ON ((pp.id_paquete = pa.id_paquete)));


ALTER VIEW public.v_promocion_paquetes OWNER TO postgres;

--
-- TOC entry 445 (class 1259 OID 31647)
-- Name: v_promocion_productos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_promocion_productos AS
 SELECT pr.id_promocion,
    pr.nombre_promocion,
    p.id_producto,
    p.nombre_producto
   FROM ((public.promocion_productos pp
     JOIN public.promociones pr ON ((pp.id_promocion = pr.id_promocion)))
     JOIN public.productos p ON ((pp.id_producto = p.id_producto)));


ALTER VIEW public.v_promocion_productos OWNER TO postgres;

--
-- TOC entry 475 (class 1259 OID 41901)
-- Name: v_promociones; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_promociones AS
 SELECT id_promocion,
    nombre_promocion,
    descripcion,
    tipo_promocion,
    valor_descuento,
        CASE
            WHEN es_permanente THEN 'Permanente'::text
            WHEN es_temporal THEN 'Temporal'::text
            ELSE 'General'::text
        END AS tipo_vigencia,
    fecha_inicio,
    fecha_fin,
    hora_inicio,
    hora_fin,
    dias_aplicables,
    solo_clientes_registrados,
    activo,
    fecha_creacion
   FROM public.promociones;


ALTER VIEW public.v_promociones OWNER TO postgres;

--
-- TOC entry 431 (class 1259 OID 23570)
-- Name: v_roles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_roles AS
 SELECT id_rol,
    nombre_rol,
    descripcion
   FROM public.roles;


ALTER VIEW public.v_roles OWNER TO postgres;

--
-- TOC entry 433 (class 1259 OID 23595)
-- Name: v_roles_permisos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_roles_permisos AS
 SELECT r.id_rol,
    r.nombre_rol,
    p.id_permiso,
    p.nombre_permiso
   FROM ((public.rol_permiso rp
     JOIN public.roles r ON ((rp.id_rol = r.id_rol)))
     JOIN public.permisos p ON ((rp.id_permiso = p.id_permiso)));


ALTER VIEW public.v_roles_permisos OWNER TO postgres;

--
-- TOC entry 474 (class 1259 OID 41897)
-- Name: v_tipo_beneficio; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_tipo_beneficio AS
 SELECT id_tipo_beneficio,
    nombre,
    descripcion,
    activo
   FROM public.tipo_beneficio;


ALTER VIEW public.v_tipo_beneficio OWNER TO postgres;

--
-- TOC entry 466 (class 1259 OID 36515)
-- Name: v_uso_beneficios; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_uso_beneficios AS
 SELECT ub.id_uso_beneficio,
    ub.id_cliente_beneficio,
    cb.id_cliente,
    c.nombre AS nombre_cliente,
    ub.id_orden,
    o.numero_orden,
    ub.cantidad_usada,
    ub.fecha_uso,
    ub.activo
   FROM (((public.uso_beneficios ub
     LEFT JOIN public.cliente_beneficio cb ON ((ub.id_cliente_beneficio = cb.id_cliente_beneficio)))
     LEFT JOIN public.clientes c ON ((cb.id_cliente = c.id_cliente)))
     LEFT JOIN public.ordenes o ON ((ub.id_orden = o.id_orden)));


ALTER VIEW public.v_uso_beneficios OWNER TO postgres;

--
-- TOC entry 438 (class 1259 OID 24824)
-- Name: v_usuarios_roles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_usuarios_roles AS
 SELECT u.id_usuario,
    u.nombre_usuario,
    r.id_rol,
    r.nombre_rol
   FROM (public.usuarios u
     JOIN public.roles r ON ((u.id_rol = r.id_rol)));


ALTER VIEW public.v_usuarios_roles OWNER TO postgres;

--
-- TOC entry 410 (class 1259 OID 20991)
-- Name: v_zonas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_zonas AS
 SELECT id_zona,
    nombre_zona,
    descripcion_zona
   FROM public.zonas
  WHERE (activo = true);


ALTER VIEW public.v_zonas OWNER TO postgres;

--
-- TOC entry 435 (class 1259 OID 23653)
-- Name: vw_menus_activos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_menus_activos AS
 SELECT id_menu,
    nombre_menu,
    descripcion,
    hora_inicio,
    hora_fin,
    dias_semana,
    fecha_inicio,
    fecha_fin
   FROM public.menus;


ALTER VIEW public.vw_menus_activos OWNER TO postgres;

--
-- TOC entry 408 (class 1259 OID 20981)
-- Name: zonas_id_zona_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.zonas_id_zona_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zonas_id_zona_seq OWNER TO postgres;

--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 408
-- Name: zonas_id_zona_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.zonas_id_zona_seq OWNED BY public.zonas.id_zona;


--
-- TOC entry 383 (class 1259 OID 17283)
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- TOC entry 377 (class 1259 OID 17120)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- TOC entry 380 (class 1259 OID 17143)
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- TOC entry 379 (class 1259 OID 17142)
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 385 (class 1259 OID 17312)
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 385
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 389 (class 1259 OID 17432)
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- TOC entry 390 (class 1259 OID 17445)
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- TOC entry 384 (class 1259 OID 17304)
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- TOC entry 386 (class 1259 OID 17322)
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 386
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 387 (class 1259 OID 17371)
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- TOC entry 388 (class 1259 OID 17385)
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- TOC entry 391 (class 1259 OID 17455)
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- TOC entry 4105 (class 2604 OID 16514)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4183 (class 2604 OID 20968)
-- Name: categoria id_categoria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria ALTER COLUMN id_categoria SET DEFAULT nextval('public.categoria_id_categoria_seq'::regclass);


--
-- TOC entry 4179 (class 2604 OID 19835)
-- Name: cliente_beneficio id_cliente_beneficio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente_beneficio ALTER COLUMN id_cliente_beneficio SET DEFAULT nextval('public.cliente_beneficio_id_cliente_beneficio_seq'::regclass);


--
-- TOC entry 4174 (class 2604 OID 19805)
-- Name: clientes id_cliente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('public.clientes_id_cliente_seq'::regclass);


--
-- TOC entry 4200 (class 2604 OID 22185)
-- Name: ingredientes id_ingrediente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes ALTER COLUMN id_ingrediente SET DEFAULT nextval('public.ingredientes_id_ingrediente_seq'::regclass);


--
-- TOC entry 4247 (class 2604 OID 41700)
-- Name: inventario id_inventario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario ALTER COLUMN id_inventario SET DEFAULT nextval('public.inventario_id_inventario_seq'::regclass);


--
-- TOC entry 4252 (class 2604 OID 41723)
-- Name: inventario_movimientos id_movimiento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_movimientos ALTER COLUMN id_movimiento SET DEFAULT nextval('public.inventario_movimientos_id_movimiento_seq'::regclass);


--
-- TOC entry 4207 (class 2604 OID 23372)
-- Name: menus id_menu; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus ALTER COLUMN id_menu SET DEFAULT nextval('public.menus_id_menu_seq'::regclass);


--
-- TOC entry 4235 (class 2604 OID 36233)
-- Name: orden_detalle_modificadores id_detalle_modificador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalle_modificadores ALTER COLUMN id_detalle_modificador SET DEFAULT nextval('public.orden_detalle_modificadores_id_detalle_modificador_seq'::regclass);


--
-- TOC entry 4231 (class 2604 OID 36177)
-- Name: orden_detalles id_orden_detalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalles ALTER COLUMN id_orden_detalle SET DEFAULT nextval('public.orden_detalles_id_orden_detalle_seq'::regclass);


--
-- TOC entry 4240 (class 2604 OID 36455)
-- Name: orden_pagos id_pago; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_pagos ALTER COLUMN id_pago SET DEFAULT nextval('public.orden_pagos_id_pago_seq'::regclass);


--
-- TOC entry 4238 (class 2604 OID 36258)
-- Name: orden_paquete_selecciones id_seleccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_paquete_selecciones ALTER COLUMN id_seleccion SET DEFAULT nextval('public.orden_paquete_selecciones_id_seleccion_seq'::regclass);


--
-- TOC entry 4217 (class 2604 OID 23501)
-- Name: ordenes id_orden; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordenes ALTER COLUMN id_orden SET DEFAULT nextval('public.ordenes_id_orden_seq'::regclass);


--
-- TOC entry 4212 (class 2604 OID 23427)
-- Name: paquete_grupos id_paquete_grupo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paquete_grupos ALTER COLUMN id_paquete_grupo SET DEFAULT nextval('public.paquete_grupos_id_paquete_grupo_seq'::regclass);


--
-- TOC entry 4209 (class 2604 OID 23406)
-- Name: paquetes id_paquete; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paquetes ALTER COLUMN id_paquete SET DEFAULT nextval('public.paquetes_id_paquete_seq'::regclass);


--
-- TOC entry 4172 (class 2604 OID 17534)
-- Name: permisos id_permiso; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos ALTER COLUMN id_permiso SET DEFAULT nextval('public.permisos_id_permiso_seq'::regclass);


--
-- TOC entry 4203 (class 2604 OID 22194)
-- Name: producto_ingrediente id_producto_ingrediente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_ingrediente ALTER COLUMN id_producto_ingrediente SET DEFAULT nextval('public.producto_ingrediente_id_producto_ingrediente_seq'::regclass);


--
-- TOC entry 4187 (class 2604 OID 20999)
-- Name: productos id_producto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN id_producto SET DEFAULT nextval('public.productos_id_producto_seq'::regclass);


--
-- TOC entry 4225 (class 2604 OID 31615)
-- Name: promociones id_promocion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promociones ALTER COLUMN id_promocion SET DEFAULT nextval('public.promociones_id_promocion_seq'::regclass);


--
-- TOC entry 4171 (class 2604 OID 17527)
-- Name: roles id_rol; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id_rol SET DEFAULT nextval('public.roles_id_rol_seq'::regclass);


--
-- TOC entry 4177 (class 2604 OID 19822)
-- Name: tipo_beneficio id_tipo_beneficio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_beneficio ALTER COLUMN id_tipo_beneficio SET DEFAULT nextval('public.tipo_beneficio_id_tipo_beneficio_seq'::regclass);


--
-- TOC entry 4243 (class 2604 OID 36482)
-- Name: uso_beneficios id_uso_beneficio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uso_beneficios ALTER COLUMN id_uso_beneficio SET DEFAULT nextval('public.uso_beneficios_id_uso_beneficio_seq'::regclass);


--
-- TOC entry 4173 (class 2604 OID 19793)
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 4185 (class 2604 OID 20985)
-- Name: zonas id_zona; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zonas ALTER COLUMN id_zona SET DEFAULT nextval('public.zonas_id_zona_seq'::regclass);


--
-- TOC entry 4801 (class 0 OID 16529)
-- Dependencies: 356
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- TOC entry 4818 (class 0 OID 17078)
-- Dependencies: 376
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4812 (class 0 OID 16883)
-- Dependencies: 370
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- TOC entry 4803 (class 0 OID 16681)
-- Dependencies: 361
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- TOC entry 4800 (class 0 OID 16522)
-- Dependencies: 355
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4807 (class 0 OID 16770)
-- Dependencies: 365
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- TOC entry 4806 (class 0 OID 16758)
-- Dependencies: 364
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- TOC entry 4805 (class 0 OID 16745)
-- Dependencies: 363
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- TOC entry 4815 (class 0 OID 16995)
-- Dependencies: 373
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- TOC entry 4817 (class 0 OID 17068)
-- Dependencies: 375
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- TOC entry 4814 (class 0 OID 16965)
-- Dependencies: 372
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- TOC entry 4816 (class 0 OID 17028)
-- Dependencies: 374
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- TOC entry 4813 (class 0 OID 16933)
-- Dependencies: 371
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4799 (class 0 OID 16511)
-- Dependencies: 354
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- TOC entry 4810 (class 0 OID 16812)
-- Dependencies: 368
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- TOC entry 4811 (class 0 OID 16830)
-- Dependencies: 369
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- TOC entry 4802 (class 0 OID 16537)
-- Dependencies: 357
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- TOC entry 4804 (class 0 OID 16711)
-- Dependencies: 362
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- TOC entry 4809 (class 0 OID 16797)
-- Dependencies: 367
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4808 (class 0 OID 16788)
-- Dependencies: 366
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- TOC entry 4797 (class 0 OID 16499)
-- Dependencies: 352
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- TOC entry 4850 (class 0 OID 21046)
-- Dependencies: 414
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- TOC entry 4849 (class 0 OID 21023)
-- Dependencies: 413
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- TOC entry 4844 (class 0 OID 20965)
-- Dependencies: 406
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria (id_categoria, nombre_cat, descripcion_cat, activo) FROM stdin;
4	Menudo	Menudo de temporada	f
3	Bebidas frías	Bebida fría	f
1	Cocina	Platillos preparados en cocina	t
2	Bebidas	Bebidas calientes y frías	t
5	Postres	Zona de postres y repostería	t
\.


--
-- TOC entry 4842 (class 0 OID 19832)
-- Dependencies: 404
-- Data for Name: cliente_beneficio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente_beneficio (id_cliente_beneficio, id_cliente, id_tipo_beneficio, cantidad_disponible, cantidad_usada, fecha_inicio, fecha_fin, dias_aplica, activo) FROM stdin;
2	1	1	4	1	2026-04-06	2026-04-30	Lunes a Viernes	f
1	1	1	25	5	2026-03-01	2026-06-30	Lunes-Viernes	t
\.


--
-- TOC entry 4838 (class 0 OID 19802)
-- Dependencies: 400
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id_cliente, nombre, email, telefono, codigo_rfid, activo, fecha_registro) FROM stdin;
4	Cynthia Pioquinto Barrios OEFOIUASEFujjy	pio@pio.com	123	\N	t	2026-03-23 04:52:07.499775
6	El Papu Leal	correoleal@papu.com	12345657	\N	t	2026-04-09 02:29:40.669826
3	Roberto Calderón	roberto@1234	442-111-7871	\N	t	2026-03-23 00:00:52.388182
1	Yuli sosa	yuli@1234	442-331-9621	29145B00	t	2026-03-19 16:47:31.917728
2	Adrian Sosa	asosa23@alumnos.uaq.mx	442-449-0070	\N	t	2026-03-20 04:41:21.32994
5	Irvin Mata	irvin@urbiola.com	246810	\N	t	2026-03-23 05:12:14.346123
\.


--
-- TOC entry 4852 (class 0 OID 22182)
-- Dependencies: 416
-- Data for Name: ingredientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredientes (id_ingrediente, nombre_ingrediente, tipo_ingrediente, precio_adicional, activo) FROM stdin;
4	Salsa	obligatorio	0.00	f
6	Azucar	opcional	0.00	f
2	Pollo	extra	15.00	f
3	Crema	opcional	0.00	f
1	Tortilla	obligatorio	0.00	f
7	Ingrediente Secreto	extra	50.00	f
5	Pan	extra	5.00	f
8	Wey soy pico de gallo ALV	opcional	25.00	f
9	Un bolillote así bien inmenso	opcional	600.00	f
11	Queso	opcional	20.00	t
12	Frijoles	opcional	50.00	t
13	Tortilla	opcional	5.00	t
14	Pollo	opcional	30.00	t
15	Cebolla	opcional	15.00	t
16	Bolillo	opcional	7.00	t
17	Pico de gallo	opcional	10.00	t
18	Chorizo	opcional	30.00	t
10	Crema	opcional	20.00	t
\.


--
-- TOC entry 4881 (class 0 OID 41697)
-- Dependencies: 469
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario (id_inventario, id_ingrediente, cantidad_actual, cantidad_minima, unidad, fecha_actualizacion, activo) FROM stdin;
1	2	9.50	2.00	kg	2026-05-13 01:05:34.030384	f
2	3	91.50	3.00	kg	2026-05-13 01:24:58.860322	t
\.


--
-- TOC entry 4883 (class 0 OID 41720)
-- Dependencies: 472
-- Data for Name: inventario_movimientos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventario_movimientos (id_movimiento, id_inventario, tipo_movimiento, cantidad, motivo, fecha_movimiento, id_usuario, activo) FROM stdin;
1	2	entrada	40.00	Compra mensual de pollo 	2026-05-13 01:24:06.22898	\N	t
2	2	entrada	40.00	Compra mensual de pollo 	2026-05-13 01:24:58.860322	\N	t
\.


--
-- TOC entry 4857 (class 0 OID 23378)
-- Dependencies: 422
-- Data for Name: menu_productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_productos (id_menu, id_producto) FROM stdin;
1	1
7	9
7	11
7	10
8	8
8	11
\.


--
-- TOC entry 4856 (class 0 OID 23369)
-- Dependencies: 421
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menus (id_menu, nombre_menu, descripcion, hora_inicio, hora_fin, dias_semana, activo, fecha_inicio, fecha_fin) FROM stdin;
3	Menú del día	Comida corrida	13:00:00	16:00:00	Lunes-Vierne	f	\N	\N
4	Menú nocturno extendido	Opciones disponibles en la noche	18:00:00	23:00:00	Viernes-Sábado	f	\N	\N
5	Menú de Verano	Incluye sopa, plato fuerte y bebida	13:00:00	16:00:00	Lunes-Viernes	f	2026-03-01	2026-12-31
1	Matutino	Desayunos	07:00:00	12:00:00	Lunes-Viernes	f	\N	\N
6	El menú que dura 1 minuto we jaja	SESENTA SEGUNDOS	08:42:00	08:43:00	Lunes-Viernes	f	\N	\N
2	Vespertino	Comidas	12:00:00	18:00:00	Lunes-Viernes	f	\N	\N
7	Menú Matutino	Menú de la mañana	08:00:00	12:30:00	Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo	t	\N	\N
8	Menú Nocturno	Menú de la noche	13:00:00	23:59:00	Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo	t	\N	\N
\.


--
-- TOC entry 4873 (class 0 OID 36230)
-- Dependencies: 456
-- Data for Name: orden_detalle_modificadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_detalle_modificadores (id_detalle_modificador, id_orden_detalle, id_ingrediente, accion, precio_modificador) FROM stdin;
1	1	1	agregar	10.00
4	3	11	agregar	0.00
5	3	13	agregar	0.00
6	3	15	agregar	0.00
7	3	10	agregar	0.00
8	4	11	agregar	0.00
9	4	13	agregar	0.00
10	4	15	agregar	0.00
11	4	10	agregar	0.00
12	5	11	agregar	0.00
13	5	13	agregar	0.00
14	5	15	agregar	0.00
15	5	10	agregar	0.00
16	6	11	agregar	0.00
17	6	13	agregar	0.00
18	6	15	agregar	0.00
19	6	10	agregar	0.00
\.


--
-- TOC entry 4871 (class 0 OID 36174)
-- Dependencies: 452
-- Data for Name: orden_detalles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_detalles (id_orden_detalle, id_orden, id_producto, id_paquete, cantidad, precio_unitario, descuento_aplicado, subtotal, id_promocion, estado_preparacion, id_zona, notas_especiales) FROM stdin;
1	1	1	\N	2	50.00	0.00	100.00	\N	pendiente	1	\N
3	8	8	\N	1	43.10	0.00	43.10	\N	pendiente	\N	\N
4	9	8	\N	1	43.10	0.00	43.10	\N	pendiente	\N	\N
5	10	8	\N	1	43.10	0.00	43.10	\N	pendiente	\N	\N
6	11	8	\N	1	43.10	0.00	43.10	\N	pendiente	\N	\N
7	12	11	\N	1	34.48	0.00	34.48	\N	pendiente	\N	\N
\.


--
-- TOC entry 4877 (class 0 OID 36452)
-- Dependencies: 461
-- Data for Name: orden_pagos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_pagos (id_pago, id_orden, metodo_pago, monto_pagado, referencia, fecha_pago, id_usuario, activo) FROM stdin;
1	1	efectivo	232.00	\N	2026-04-11 05:35:13.973443	1	t
2	7	efectivo	232.00	\N	2026-04-11 05:44:55.703163	1	t
3	3	efectivo	180.00	CORRECCION-TICKET-445	2026-04-11 05:54:17.660199	\N	f
4	11	tarjeta	50.00	\N	2026-05-19 20:12:45.389318	\N	t
5	12	efectivo	40.00	\N	2026-05-19 20:18:37.747057	\N	t
\.


--
-- TOC entry 4875 (class 0 OID 36255)
-- Dependencies: 459
-- Data for Name: orden_paquete_selecciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_paquete_selecciones (id_seleccion, id_orden_detalle, id_paquete_grupo, id_producto, cantidad) FROM stdin;
2	1	2	4	1
\.


--
-- TOC entry 4864 (class 0 OID 23498)
-- Dependencies: 430
-- Data for Name: ordenes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ordenes (id_orden, numero_orden, id_usuario, id_cliente, tipo_orden, mesa_numero, subtotal, descuento, impuestos, total, estado_orden, estado_pago, metodo_pago, notas_orden, fecha_creacion, fecha_actualizacion, fecha_entrega) FROM stdin;
6	TICKET-002	\N	\N	local	Mesa 5	150.00	0.00	24.00	174.00	cancelada	pagado	tarjeta	Sin cebolla en el bagel y café muy caliente	2026-04-10 22:36:00.030593	2026-04-10 22:45:11.421965	2026-04-10 16:30:00
1	ORD-001	1	1	local	Mesa 5	55.00	0.00	0.00	55.00	lista	pendiente	\N	\N	2026-03-23 00:23:04.393905	2026-05-18 02:55:57.887898	\N
4	TICKET-001	\N	\N	local	Mesa 5	150.00	0.00	24.00	174.00	lista	pendiente	\N	Sin cebolla en el bagel y café muy caliente	2026-04-10 22:30:24.167884	2026-05-18 02:55:59.725625	\N
7	ORD-1001	1	\N	local	M5	200.00	0.00	0.00	232.00	lista	pagado	efectivo	Sin picante	2026-04-11 02:44:42.675076	2026-05-18 02:56:00.154839	\N
3	ORD-002	1	\N	para_llevar	\N	70.00	0.00	0.00	70.00	lista	pagado	tarjeta	\N	2026-03-23 00:24:47.265801	2026-05-18 02:56:00.937866	\N
8	ORD-1779218795512	7	\N	local	\N	43.10	0.00	6.90	50.00	pendiente	pendiente	\N	\N	2026-05-19 19:26:35.43393	2026-05-19 19:26:35.43393	\N
9	ORD-1779220709021	7	\N	local	\N	43.10	0.00	6.90	50.00	pendiente	pendiente	\N	\N	2026-05-19 19:58:28.814595	2026-05-19 19:58:28.814595	\N
10	ORD-1779221532853	7	\N	local	\N	43.10	0.00	6.90	50.00	pendiente	pendiente	\N	\N	2026-05-19 20:12:12.530494	2026-05-19 20:12:12.530494	\N
11	ORD-1779221563244	7	\N	local	\N	43.10	0.00	6.90	50.00	pendiente	pagado	tarjeta	\N	2026-05-19 20:12:43.383465	2026-05-19 20:12:43.383465	\N
12	ORD-1779221916899	7	\N	local	\N	34.48	0.00	5.52	40.00	pendiente	pagado	efectivo	\N	2026-05-19 20:18:36.683078	2026-05-19 20:18:36.683078	\N
\.


--
-- TOC entry 4862 (class 0 OID 23437)
-- Dependencies: 427
-- Data for Name: paquete_grupo_productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paquete_grupo_productos (id_paquete_grupo, id_producto, precio_adicional) FROM stdin;
1	1	0.00
6	8	0.00
6	10	0.00
7	9	0.00
7	11	0.00
8	8	0.00
8	10	0.00
9	9	0.00
9	11	0.00
10	10	0.00
10	8	0.00
11	9	0.00
11	11	0.00
12	10	0.00
12	8	0.00
13	9	0.00
13	11	0.00
14	10	0.00
14	8	0.00
15	11	0.00
15	9	0.00
16	10	0.00
16	8	0.00
17	9	0.00
17	11	0.00
22	10	0.00
22	8	0.00
23	9	0.00
23	11	0.00
\.


--
-- TOC entry 4861 (class 0 OID 23424)
-- Dependencies: 426
-- Data for Name: paquete_grupos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paquete_grupos (id_paquete_grupo, id_paquete, nombre_grupo, seleccion_obligatoria, cantidad_selecciones, activo) FROM stdin;
1	1	Platillo principal	t	1	t
2	1	Bebida	t	1	t
4	2	Bebida	t	1	t
3	1	Complemento	f	2	t
5	3	bebida caliente	t	1	t
6	6	plat	t	1	f
7	6	bebida	t	1	f
8	6	plat	t	1	f
9	6	bebida	t	1	f
10	6	plat	t	1	f
11	6	bebida	t	1	f
12	6	plat	t	1	f
13	6	bebida	t	1	f
14	6	plat	t	1	f
15	6	bebida	t	1	f
16	6	plat	f	1	f
17	6	bebida	t	1	f
18	6	plat	t	1	f
19	6	bebida	t	1	f
20	6	plat	f	1	f
21	6	bebida	t	1	f
22	6	plat	t	1	t
23	6	bebida	t	1	t
\.


--
-- TOC entry 4859 (class 0 OID 23403)
-- Dependencies: 424
-- Data for Name: paquetes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paquetes (id_paquete, nombre_paquete, descripcion, precio_paquete, activo, es_temporal, fecha_inicio, fecha_fin, dias_disponibles, url_imagen) FROM stdin;
4	El paquete que te da 3 quesos pa	manchego y manchego y luego un manchego	12.00	f	f	\N	\N	\N	\N
1	Desayuno sencillo	Chilaquiles + café + fruta	55.00	f	t	2026-03-01 07:00:00	2026-06-30 12:00:00	Lunes-Viernes	https://ctvpvvlaralnelutzyjk.supabase.co/storage/v1/object/public/Paquetes/desa1.jpg
2	Desayuno 2	Chilaquiles + bebida + complemento + 2 huevos	75.00	f	t	2026-03-01 07:00:00	2026-06-30 12:00:00	Lunes-Viernes	\N
3	Paquete el rio	Comida corrida mas postre	49.90	f	f	2026-04-01 08:00:00	2026-04-07 20:00:00	\N	https://coffeecode.com/promo-verano.jpg
5	Paquetón 30 cm	lince	1200.00	f	f	\N	\N	\N	\N
6	pp #1	afdaefa	50.00	t	f	\N	\N	Lunes, Jueves, Sábado	\N
\.


--
-- TOC entry 4833 (class 0 OID 17531)
-- Dependencies: 395
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permisos (id_permiso, nombre_permiso) FROM stdin;
1	crear_pedido
2	ver_pedidos
3	administrar_menu
4	administrar_usuarios
\.


--
-- TOC entry 4854 (class 0 OID 22191)
-- Dependencies: 418
-- Data for Name: producto_ingrediente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto_ingrediente (id_producto_ingrediente, id_producto, id_ingrediente, es_obligatorio, precio_modificador, activo) FROM stdin;
5	1	1	t	0.00	t
6	1	4	t	0.00	t
7	1	3	f	0.00	t
8	1	2	f	15.00	t
9	1	5	f	5.00	t
10	2	6	t	0.50	f
11	8	11	f	0.00	t
12	8	13	f	0.00	t
13	8	15	f	0.00	t
14	8	10	f	0.00	t
15	8	12	f	0.00	t
16	10	16	f	0.00	t
17	10	12	f	0.00	t
18	10	11	f	0.00	t
19	10	17	f	0.00	t
\.


--
-- TOC entry 4848 (class 0 OID 20996)
-- Dependencies: 412
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (id_producto, nombre_producto, descripcion_pro, precio_base, id_zona, id_categoria, disponibilidad, url_imagen) FROM stdin;
2	Cafe de olla	Delicioso café de olla	15.00	1	2	f	aqui deberia ir el cafe
3	Frappe de guanabana (Grande)	Frappe especial de temporada	60.00	2	2	f	frappe_guanabanajpg
5	Papu producto PRO	\N	60.00	2	2	f	\N
7	Queso JAJAJAJAJA	rgrgrgrgr	250.00	2	1	f	https://png.pngtree.com/png-clipart/20250120/original/pngtree-cartoon-cheese-mascot-vector-png-image_19952012.png
4	Molletes	\N	30.00	3	1	f	\N
6	Producto Papu 2	\N	10.00	4	1	f	no se xd
1	Chilaquiles verdes	Totopos con salsa verde	55.00	1	1	f	https://ctvpvvlaralnelutzyjk.supabase.co/storage/v1/object/public/productos/chilaquiles_foto.png
9	Café americano	\N	15.00	7	2	t	https://cdn0.recetasgratis.net/es/posts/4/2/6/cafe_americano_19624_orig.jpg
11	Jugo de naranja	\N	40.00	7	2	t	https://yosoyvendedor.com/source/a9a00265440312d44769b4489abda0a8/jugo-naranja.png
10	Molletes	\N	40.00	8	1	t	https://www.recetasnestle.com.mx/sites/default/files/styles/recipe_detail_mobile/public/srh_recipes/695857c6830e854209ac056a183fc09c.png?itok=dgUkX8LT
8	Enfrijoladas	Tortillas con frijol	50.00	8	1	t	https://i.blogs.es/6507e2/enfrijoladas-caseras/650_1200.jpg
\.


--
-- TOC entry 4869 (class 0 OID 31682)
-- Dependencies: 448
-- Data for Name: promocion_clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promocion_clientes (id_promocion, id_cliente) FROM stdin;
4	3
4	4
4	2
6	2
5	5
6	5
4	5
\.


--
-- TOC entry 4868 (class 0 OID 31654)
-- Dependencies: 446
-- Data for Name: promocion_paquetes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promocion_paquetes (id_promocion, id_paquete) FROM stdin;
\.


--
-- TOC entry 4867 (class 0 OID 31632)
-- Dependencies: 444
-- Data for Name: promocion_productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promocion_productos (id_promocion, id_producto) FROM stdin;
4	9
4	11
5	10
5	8
6	10
6	11
\.


--
-- TOC entry 4866 (class 0 OID 31612)
-- Dependencies: 443
-- Data for Name: promociones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promociones (id_promocion, nombre_promocion, descripcion, tipo_promocion, valor_descuento, es_temporal, fecha_inicio, fecha_fin, hora_inicio, hora_fin, dias_aplicables, es_permanente, solo_clientes_registrados, activo, fecha_creacion) FROM stdin;
6	50% en molletes o jugo	y5y5y	2x1	0.00	f	\N	\N	\N	\N	{Lunes}	t	f	f	2026-05-19 04:46:25.034405
5	2x1 en platillos	2x1 en platillos	2x1	0.00	f	\N	\N	\N	\N	{Lunes,Jueves,Viernes,Martes}	t	t	t	2026-05-19 03:38:38.600317
4	mar sab 2x1 bebidas	2z111	2x1	0.00	f	\N	\N	\N	\N	{Martes,Sábado,Domingo}	t	t	t	2026-05-16 22:48:46.317926
\.


--
-- TOC entry 4834 (class 0 OID 17537)
-- Dependencies: 396
-- Data for Name: rol_permiso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol_permiso (id_rol, id_permiso) FROM stdin;
1	1
1	2
1	3
1	4
4	2
4	1
2	4
\.


--
-- TOC entry 4831 (class 0 OID 17524)
-- Dependencies: 393
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id_rol, nombre_rol, descripcion) FROM stdin;
1	Administrador	Control total del sistema
2	Caja	Registro de pedidos
3	Cocina	Preparación de alimentos
4	Bebidas	Preparación de bebidas
6	Seguridad	Guardia de seguridad del establecimiento
\.


--
-- TOC entry 4840 (class 0 OID 19819)
-- Dependencies: 402
-- Data for Name: tipo_beneficio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_beneficio (id_tipo_beneficio, nombre, descripcion, activo) FROM stdin;
1	Beca alimenticia	Incluye un desayuno sencillo o menu troyano	t
3	Descuento de estudiante	Reduce el precio del producto	t
5	Cumpleaños VIP	Descuento especial para clientes VIP	f
\.


--
-- TOC entry 4879 (class 0 OID 36479)
-- Dependencies: 464
-- Data for Name: uso_beneficios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uso_beneficios (id_uso_beneficio, id_cliente_beneficio, id_orden, cantidad_usada, fecha_uso, activo) FROM stdin;
4	2	1	1	2026-05-13 00:15:34.526347	t
1	1	1	2	2026-04-11 05:51:54.21505	f
\.


--
-- TOC entry 4836 (class 0 OID 19790)
-- Dependencies: 398
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id_usuario, nombre_usuario, contra, id_rol) FROM stdin;
1	admin	admin1	1
2	Prueba1	123	1
3	Prueba2	$2b$10$q3PViJyw92uNOvreU6lTXOl54GyAnwu0/UXF3GSu7f7CexIARf5Wq	1
10	elpapupro	$2b$10$i0ffurGo2gTmk/wslzzyOueHqCAfGa6fwmfRxzWg2eHst6EogggZW	2
7	admin2	$2b$10$h.pV/rln2YSPX/brVUcaqu27Yw7XaseBcpqPYrXyKmWGlpSqRPhwq	1
\.


--
-- TOC entry 4846 (class 0 OID 20982)
-- Dependencies: 409
-- Data for Name: zonas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zonas (id_zona, nombre_zona, descripcion_zona, activo) FROM stdin;
1	Cocina	Área de preparación de alimentos	f
6	Cocina	QUE TE IMPORTA	f
2	Bebidas	Área de preparación de té	f
3	Bar	Área de preparación para cortes de carne	f
4	Terraza Exterior	Zona exterior con mesas de plastico	f
5	Postres	Zona de postres y repostería	f
7	Bebidas	Zona donde se preparan todas las bebidas.	t
8	Cocina	Zona donde se prepara todos los platillos	t
\.


--
-- TOC entry 4819 (class 0 OID 17120)
-- Dependencies: 377
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-16 02:41:11
20211116045059	2026-03-16 02:41:11
20211116050929	2026-03-16 02:41:11
20211116051442	2026-03-16 02:41:11
20211116212300	2026-03-16 02:41:11
20211116213355	2026-03-16 02:41:11
20211116213934	2026-03-16 02:41:11
20211116214523	2026-03-16 02:41:11
20211122062447	2026-03-16 02:41:11
20211124070109	2026-03-16 02:41:11
20211202204204	2026-03-16 02:41:11
20211202204605	2026-03-16 02:41:11
20211210212804	2026-03-16 02:41:11
20211228014915	2026-03-16 02:41:11
20220107221237	2026-03-16 02:41:11
20220228202821	2026-03-16 02:41:11
20220312004840	2026-03-16 02:41:11
20220603231003	2026-03-16 02:41:11
20220603232444	2026-03-16 02:41:11
20220615214548	2026-03-16 02:41:11
20220712093339	2026-03-16 02:41:11
20220908172859	2026-03-16 02:41:11
20220916233421	2026-03-16 02:41:11
20230119133233	2026-03-16 02:41:11
20230128025114	2026-03-16 02:41:11
20230128025212	2026-03-16 02:41:11
20230227211149	2026-03-16 02:41:11
20230228184745	2026-03-16 02:41:12
20230308225145	2026-03-16 02:41:12
20230328144023	2026-03-16 02:41:12
20231018144023	2026-03-16 02:41:12
20231204144023	2026-03-16 02:41:12
20231204144024	2026-03-16 02:41:12
20231204144025	2026-03-16 02:41:12
20240108234812	2026-03-16 02:41:12
20240109165339	2026-03-16 02:41:12
20240227174441	2026-03-16 02:41:12
20240311171622	2026-03-16 02:41:12
20240321100241	2026-03-16 02:41:12
20240401105812	2026-03-16 02:41:12
20240418121054	2026-03-16 02:41:12
20240523004032	2026-03-16 02:41:12
20240618124746	2026-03-16 02:41:12
20240801235015	2026-03-16 02:41:12
20240805133720	2026-03-16 02:41:12
20240827160934	2026-03-16 02:41:12
20240919163303	2026-03-16 02:41:12
20240919163305	2026-03-16 02:41:12
20241019105805	2026-03-16 02:41:12
20241030150047	2026-03-16 02:41:12
20241108114728	2026-03-16 02:41:12
20241121104152	2026-03-16 02:41:12
20241130184212	2026-03-16 02:41:12
20241220035512	2026-03-16 02:41:12
20241220123912	2026-03-16 02:41:12
20241224161212	2026-03-16 02:41:12
20250107150512	2026-03-16 02:41:12
20250110162412	2026-03-16 02:41:12
20250123174212	2026-03-16 02:41:12
20250128220012	2026-03-16 02:41:12
20250506224012	2026-03-16 02:41:12
20250523164012	2026-03-16 02:41:12
20250714121412	2026-03-16 02:41:12
20250905041441	2026-03-16 02:41:12
20251103001201	2026-03-16 02:41:12
20251120212548	2026-03-16 02:41:12
20251120215549	2026-03-16 02:41:12
20260218120000	2026-03-16 02:41:12
20260326120000	2026-04-10 03:58:28
\.


--
-- TOC entry 4821 (class 0 OID 17143)
-- Dependencies: 380
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- TOC entry 4823 (class 0 OID 17312)
-- Dependencies: 385
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
productos	productos	\N	2026-03-20 04:48:52.847523+00	2026-03-20 04:48:52.847523+00	t	f	\N	\N	\N	STANDARD
Paquetes	Paquetes	\N	2026-03-22 23:49:38.38259+00	2026-03-22 23:49:38.38259+00	t	f	\N	\N	\N	STANDARD
\.


--
-- TOC entry 4827 (class 0 OID 17432)
-- Dependencies: 389
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- TOC entry 4828 (class 0 OID 17445)
-- Dependencies: 390
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4822 (class 0 OID 17304)
-- Dependencies: 384
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-16 02:41:19.830322
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-16 02:41:19.838133
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-16 02:41:19.84705
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-16 02:41:19.862911
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-16 02:41:19.871874
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-16 02:41:19.876956
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-16 02:41:19.88291
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-16 02:41:19.88849
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-16 02:41:19.893615
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-16 02:41:19.898779
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-16 02:41:19.904908
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-16 02:41:19.910133
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-16 02:41:19.916271
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-16 02:41:19.921465
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-16 02:41:19.926758
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-16 02:41:19.954208
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-16 02:41:19.95966
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-16 02:41:19.964792
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-16 02:41:19.969883
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-16 02:41:19.976828
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-16 02:41:19.982107
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-16 02:41:19.988717
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-16 02:41:20.001618
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-16 02:41:20.012219
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-16 02:41:20.017619
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-16 02:41:20.022757
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-16 02:41:20.027916
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-16 02:41:20.032708
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-16 02:41:20.037522
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-16 02:41:20.042416
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-16 02:41:20.04715
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-16 02:41:20.051927
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-16 02:41:20.056661
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-16 02:41:20.06151
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-16 02:41:20.066408
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-16 02:41:20.071226
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-16 02:41:20.076131
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-16 02:41:20.081002
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-16 02:41:20.088218
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-16 02:41:20.09881
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-16 02:41:20.103624
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-16 02:41:20.108411
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-16 02:41:20.11323
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-16 02:41:20.118415
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-16 02:41:20.123717
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-16 02:41:20.129376
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-16 02:41:20.141119
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-16 02:41:20.146614
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-16 02:41:20.15152
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-16 02:41:20.166807
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-16 02:41:20.17201
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-16 02:41:20.236125
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-03-16 02:41:20.238311
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-16 02:41:20.249884
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-16 02:41:20.253034
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-16 02:41:20.255082
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-02 18:48:21.245066
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-02 18:48:21.272269
56	fix-optimized-search-function	b823ed1e418101032fa01374edc9a436e54e3ed4	2026-03-16 02:41:20.261022
59	drop-unused-functions	38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4	2026-05-01 22:55:20.324962
60	optimize-existing-functions-again	db35e1c91a9201e59f4fef8d972c2f277d68b157	2026-05-01 22:55:20.335983
\.


--
-- TOC entry 4824 (class 0 OID 17322)
-- Dependencies: 386
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
5a12fe24-a933-4645-b53c-6a0dc3098d68	productos	chilaquiles_foto.png	\N	2026-03-20 04:50:17.992499+00	2026-03-20 04:50:17.992499+00	2026-03-20 04:50:17.992499+00	{"eTag": "\\"2489c6c5012c7c86adbc40aedfc9a8bf-1\\"", "size": 1150704, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-20T04:50:17.000Z", "contentLength": 1150704, "httpStatusCode": 200}	7ee09daa-aac0-49bc-81b7-943740630245	\N	\N
b1c22340-6c61-4aa5-a13c-9f97e45bbe94	Paquetes	desa1.jpg	\N	2026-03-22 23:49:55.611635+00	2026-03-22 23:49:55.611635+00	2026-03-22 23:49:55.611635+00	{"eTag": "\\"523d411af22264275e0a300e3dc81e84-1\\"", "size": 45852, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-22T23:49:56.000Z", "contentLength": 45852, "httpStatusCode": 200}	1fe5023b-4e12-4163-9b16-d07586086591	\N	\N
9f7a20b3-7434-40c5-b195-056279a88b85	productos	Cafe.jpg	\N	2026-03-23 01:17:46.599583+00	2026-03-23 01:17:46.599583+00	2026-03-23 01:17:46.599583+00	{"eTag": "\\"b22891e1338313d651aa135fdb853b0a-1\\"", "size": 223755, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T01:17:46.000Z", "contentLength": 223755, "httpStatusCode": 200}	b110a3b8-329d-46e7-884a-9591025d7c78	\N	\N
\.


--
-- TOC entry 4825 (class 0 OID 17371)
-- Dependencies: 387
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
\.


--
-- TOC entry 4826 (class 0 OID 17385)
-- Dependencies: 388
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- TOC entry 4829 (class 0 OID 17455)
-- Dependencies: 391
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4095 (class 0 OID 16612)
-- Dependencies: 358
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 353
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 405
-- Name: categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_id_categoria_seq', 5, true);


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 403
-- Name: cliente_beneficio_id_cliente_beneficio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_beneficio_id_cliente_beneficio_seq', 2, true);


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 399
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_cliente_seq', 6, true);


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 415
-- Name: ingredientes_id_ingrediente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredientes_id_ingrediente_seq', 18, true);


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 468
-- Name: inventario_id_inventario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_id_inventario_seq', 2, true);


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 471
-- Name: inventario_movimientos_id_movimiento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventario_movimientos_id_movimiento_seq', 2, true);


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 420
-- Name: menus_id_menu_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menus_id_menu_seq', 8, true);


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 455
-- Name: orden_detalle_modificadores_id_detalle_modificador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orden_detalle_modificadores_id_detalle_modificador_seq', 19, true);


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 451
-- Name: orden_detalles_id_orden_detalle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orden_detalles_id_orden_detalle_seq', 7, true);


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 460
-- Name: orden_pagos_id_pago_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orden_pagos_id_pago_seq', 5, true);


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 458
-- Name: orden_paquete_selecciones_id_seleccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orden_paquete_selecciones_id_seleccion_seq', 2, true);


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 429
-- Name: ordenes_id_orden_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ordenes_id_orden_seq', 12, true);


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 425
-- Name: paquete_grupos_id_paquete_grupo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paquete_grupos_id_paquete_grupo_seq', 23, true);


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 423
-- Name: paquetes_id_paquete_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paquetes_id_paquete_seq', 6, true);


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 394
-- Name: permisos_id_permiso_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permisos_id_permiso_seq', 5, true);


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 417
-- Name: producto_ingrediente_id_producto_ingrediente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_ingrediente_id_producto_ingrediente_seq', 19, true);


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 411
-- Name: productos_id_producto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_id_producto_seq', 11, true);


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 442
-- Name: promociones_id_promocion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promociones_id_promocion_seq', 6, true);


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 392
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_rol_seq', 6, true);


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 401
-- Name: tipo_beneficio_id_tipo_beneficio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_beneficio_id_tipo_beneficio_seq', 5, true);


--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 463
-- Name: uso_beneficios_id_uso_beneficio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uso_beneficios_id_uso_beneficio_seq', 4, true);


--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 397
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 10, true);


--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 408
-- Name: zonas_id_zona_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zonas_id_zona_seq', 8, true);


--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 379
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- TOC entry 4357 (class 2606 OID 16783)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4326 (class 2606 OID 16535)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4412 (class 2606 OID 17115)
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- TOC entry 4414 (class 2606 OID 17113)
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4380 (class 2606 OID 16889)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4335 (class 2606 OID 16907)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4337 (class 2606 OID 16917)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4324 (class 2606 OID 16528)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4359 (class 2606 OID 16776)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4355 (class 2606 OID 16764)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4347 (class 2606 OID 16957)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4349 (class 2606 OID 16751)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4393 (class 2606 OID 17016)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4395 (class 2606 OID 17014)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4397 (class 2606 OID 17012)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4407 (class 2606 OID 17074)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4390 (class 2606 OID 16976)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4401 (class 2606 OID 17038)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4403 (class 2606 OID 17040)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4384 (class 2606 OID 16942)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4318 (class 2606 OID 16518)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4321 (class 2606 OID 16694)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4369 (class 2606 OID 16823)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4371 (class 2606 OID 16821)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4376 (class 2606 OID 16837)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4329 (class 2606 OID 16541)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4342 (class 2606 OID 16715)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4366 (class 2606 OID 16804)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4361 (class 2606 OID 16795)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4311 (class 2606 OID 16877)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4313 (class 2606 OID 16505)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4481 (class 2606 OID 21055)
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4477 (class 2606 OID 21038)
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4470 (class 2606 OID 20973)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 4468 (class 2606 OID 19840)
-- Name: cliente_beneficio cliente_beneficio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente_beneficio
    ADD CONSTRAINT cliente_beneficio_pkey PRIMARY KEY (id_cliente_beneficio);


--
-- TOC entry 4460 (class 2606 OID 19813)
-- Name: clientes clientes_codigo_rfid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_codigo_rfid_key UNIQUE (codigo_rfid);


--
-- TOC entry 4462 (class 2606 OID 19811)
-- Name: clientes clientes_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_email_key UNIQUE (email);


--
-- TOC entry 4464 (class 2606 OID 19809)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- TOC entry 4484 (class 2606 OID 22189)
-- Name: ingredientes ingredientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredientes
    ADD CONSTRAINT ingredientes_pkey PRIMARY KEY (id_ingrediente);


--
-- TOC entry 4522 (class 2606 OID 41728)
-- Name: inventario_movimientos inventario_movimientos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_movimientos
    ADD CONSTRAINT inventario_movimientos_pkey PRIMARY KEY (id_movimiento);


--
-- TOC entry 4520 (class 2606 OID 41706)
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);


--
-- TOC entry 4490 (class 2606 OID 23382)
-- Name: menu_productos menu_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_productos
    ADD CONSTRAINT menu_productos_pkey PRIMARY KEY (id_menu, id_producto);


--
-- TOC entry 4488 (class 2606 OID 23377)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id_menu);


--
-- TOC entry 4512 (class 2606 OID 36237)
-- Name: orden_detalle_modificadores orden_detalle_modificadores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalle_modificadores
    ADD CONSTRAINT orden_detalle_modificadores_pkey PRIMARY KEY (id_detalle_modificador);


--
-- TOC entry 4510 (class 2606 OID 36185)
-- Name: orden_detalles orden_detalles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalles
    ADD CONSTRAINT orden_detalles_pkey PRIMARY KEY (id_orden_detalle);


--
-- TOC entry 4516 (class 2606 OID 36459)
-- Name: orden_pagos orden_pagos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_pagos
    ADD CONSTRAINT orden_pagos_pkey PRIMARY KEY (id_pago);


--
-- TOC entry 4514 (class 2606 OID 36262)
-- Name: orden_paquete_selecciones orden_paquete_selecciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_paquete_selecciones
    ADD CONSTRAINT orden_paquete_selecciones_pkey PRIMARY KEY (id_seleccion);


--
-- TOC entry 4498 (class 2606 OID 23514)
-- Name: ordenes ordenes_numero_orden_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT ordenes_numero_orden_key UNIQUE (numero_orden);


--
-- TOC entry 4500 (class 2606 OID 23512)
-- Name: ordenes ordenes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT ordenes_pkey PRIMARY KEY (id_orden);


--
-- TOC entry 4496 (class 2606 OID 23442)
-- Name: paquete_grupo_productos paquete_grupo_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paquete_grupo_productos
    ADD CONSTRAINT paquete_grupo_productos_pkey PRIMARY KEY (id_paquete_grupo, id_producto);


--
-- TOC entry 4494 (class 2606 OID 23431)
-- Name: paquete_grupos paquete_grupos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paquete_grupos
    ADD CONSTRAINT paquete_grupos_pkey PRIMARY KEY (id_paquete_grupo);


--
-- TOC entry 4492 (class 2606 OID 23412)
-- Name: paquetes paquetes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paquetes
    ADD CONSTRAINT paquetes_pkey PRIMARY KEY (id_paquete);


--
-- TOC entry 4454 (class 2606 OID 17536)
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (id_permiso);


--
-- TOC entry 4486 (class 2606 OID 22199)
-- Name: producto_ingrediente producto_ingrediente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_ingrediente
    ADD CONSTRAINT producto_ingrediente_pkey PRIMARY KEY (id_producto_ingrediente);


--
-- TOC entry 4474 (class 2606 OID 21004)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id_producto);


--
-- TOC entry 4508 (class 2606 OID 31686)
-- Name: promocion_clientes promocion_clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_clientes
    ADD CONSTRAINT promocion_clientes_pkey PRIMARY KEY (id_promocion, id_cliente);


--
-- TOC entry 4506 (class 2606 OID 31658)
-- Name: promocion_paquetes promocion_paquetes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_paquetes
    ADD CONSTRAINT promocion_paquetes_pkey PRIMARY KEY (id_promocion, id_paquete);


--
-- TOC entry 4504 (class 2606 OID 31636)
-- Name: promocion_productos promocion_productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_productos
    ADD CONSTRAINT promocion_productos_pkey PRIMARY KEY (id_promocion, id_producto);


--
-- TOC entry 4502 (class 2606 OID 31624)
-- Name: promociones promociones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promociones
    ADD CONSTRAINT promociones_pkey PRIMARY KEY (id_promocion);


--
-- TOC entry 4456 (class 2606 OID 17541)
-- Name: rol_permiso rol_permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_pkey PRIMARY KEY (id_rol, id_permiso);


--
-- TOC entry 4452 (class 2606 OID 17529)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 4466 (class 2606 OID 19826)
-- Name: tipo_beneficio tipo_beneficio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_beneficio
    ADD CONSTRAINT tipo_beneficio_pkey PRIMARY KEY (id_tipo_beneficio);


--
-- TOC entry 4518 (class 2606 OID 36487)
-- Name: uso_beneficios uso_beneficios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uso_beneficios
    ADD CONSTRAINT uso_beneficios_pkey PRIMARY KEY (id_uso_beneficio);


--
-- TOC entry 4458 (class 2606 OID 19795)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4472 (class 2606 OID 20990)
-- Name: zonas zonas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zonas
    ADD CONSTRAINT zonas_pkey PRIMARY KEY (id_zona);


--
-- TOC entry 4424 (class 2606 OID 17297)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4420 (class 2606 OID 17151)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4417 (class 2606 OID 17124)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4444 (class 2606 OID 17478)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4431 (class 2606 OID 17320)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4447 (class 2606 OID 17454)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4426 (class 2606 OID 17311)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4428 (class 2606 OID 17309)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4437 (class 2606 OID 17332)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4442 (class 2606 OID 17394)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4440 (class 2606 OID 17379)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4450 (class 2606 OID 17464)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4327 (class 1259 OID 16536)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4301 (class 1259 OID 16704)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4408 (class 1259 OID 17119)
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- TOC entry 4409 (class 1259 OID 17118)
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- TOC entry 4410 (class 1259 OID 17116)
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- TOC entry 4415 (class 1259 OID 17117)
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- TOC entry 4302 (class 1259 OID 16706)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4303 (class 1259 OID 16707)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4345 (class 1259 OID 16785)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4378 (class 1259 OID 16893)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4333 (class 1259 OID 16873)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 4333
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4338 (class 1259 OID 16701)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4381 (class 1259 OID 16890)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4405 (class 1259 OID 17075)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4382 (class 1259 OID 16891)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4353 (class 1259 OID 16896)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4350 (class 1259 OID 16757)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4351 (class 1259 OID 16902)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4391 (class 1259 OID 17027)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4388 (class 1259 OID 16980)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4398 (class 1259 OID 17053)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4399 (class 1259 OID 17051)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4404 (class 1259 OID 17052)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4385 (class 1259 OID 16949)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4386 (class 1259 OID 16948)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4387 (class 1259 OID 16950)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4304 (class 1259 OID 16708)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4305 (class 1259 OID 16705)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4314 (class 1259 OID 16519)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4315 (class 1259 OID 16520)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4316 (class 1259 OID 16700)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4319 (class 1259 OID 16787)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4322 (class 1259 OID 16892)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4372 (class 1259 OID 16829)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4373 (class 1259 OID 16894)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4374 (class 1259 OID 16844)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4377 (class 1259 OID 16843)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4339 (class 1259 OID 16895)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4340 (class 1259 OID 17065)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4343 (class 1259 OID 16786)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4364 (class 1259 OID 16811)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4367 (class 1259 OID 16810)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4362 (class 1259 OID 16796)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4363 (class 1259 OID 16958)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4352 (class 1259 OID 16955)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4344 (class 1259 OID 16784)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4306 (class 1259 OID 16864)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 4306
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4307 (class 1259 OID 16702)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4308 (class 1259 OID 16509)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4309 (class 1259 OID 16919)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4479 (class 1259 OID 21062)
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- TOC entry 4482 (class 1259 OID 21061)
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- TOC entry 4475 (class 1259 OID 21044)
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- TOC entry 4478 (class 1259 OID 21045)
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- TOC entry 4418 (class 1259 OID 17298)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4422 (class 1259 OID 17299)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4421 (class 1259 OID 17302)
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- TOC entry 4429 (class 1259 OID 17321)
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4432 (class 1259 OID 17338)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4445 (class 1259 OID 17479)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4438 (class 1259 OID 17405)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4433 (class 1259 OID 17370)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4434 (class 1259 OID 17486)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4435 (class 1259 OID 17339)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4448 (class 1259 OID 17470)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4584 (class 2620 OID 17156)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4585 (class 2620 OID 17424)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4586 (class 2620 OID 17488)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4587 (class 2620 OID 17489)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4588 (class 2620 OID 17358)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4524 (class 2606 OID 16688)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4529 (class 2606 OID 16777)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4528 (class 2606 OID 16765)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4527 (class 2606 OID 16752)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4535 (class 2606 OID 17017)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4536 (class 2606 OID 17022)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4537 (class 2606 OID 17046)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4538 (class 2606 OID 17041)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4534 (class 2606 OID 16943)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4523 (class 2606 OID 16721)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4531 (class 2606 OID 16824)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4532 (class 2606 OID 16897)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4533 (class 2606 OID 16838)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4525 (class 2606 OID 17060)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4526 (class 2606 OID 16716)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4530 (class 2606 OID 16805)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4552 (class 2606 OID 21056)
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4551 (class 2606 OID 21039)
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4547 (class 2606 OID 19841)
-- Name: cliente_beneficio fk_cb_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente_beneficio
    ADD CONSTRAINT fk_cb_cliente FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente);


--
-- TOC entry 4548 (class 2606 OID 19846)
-- Name: cliente_beneficio fk_cb_tipo_beneficio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente_beneficio
    ADD CONSTRAINT fk_cb_tipo_beneficio FOREIGN KEY (id_tipo_beneficio) REFERENCES public.tipo_beneficio(id_tipo_beneficio);


--
-- TOC entry 4582 (class 2606 OID 41707)
-- Name: inventario fk_inv_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT fk_inv_ingrediente FOREIGN KEY (id_ingrediente) REFERENCES public.ingredientes(id_ingrediente);


--
-- TOC entry 4583 (class 2606 OID 41729)
-- Name: inventario_movimientos fk_mov_inventario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventario_movimientos
    ADD CONSTRAINT fk_mov_inventario FOREIGN KEY (id_inventario) REFERENCES public.inventario(id_inventario);


--
-- TOC entry 4568 (class 2606 OID 36186)
-- Name: orden_detalles fk_od_orden; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalles
    ADD CONSTRAINT fk_od_orden FOREIGN KEY (id_orden) REFERENCES public.ordenes(id_orden) ON DELETE CASCADE;


--
-- TOC entry 4569 (class 2606 OID 36196)
-- Name: orden_detalles fk_od_paquete; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalles
    ADD CONSTRAINT fk_od_paquete FOREIGN KEY (id_paquete) REFERENCES public.paquetes(id_paquete);


--
-- TOC entry 4570 (class 2606 OID 36191)
-- Name: orden_detalles fk_od_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalles
    ADD CONSTRAINT fk_od_producto FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto);


--
-- TOC entry 4571 (class 2606 OID 36201)
-- Name: orden_detalles fk_od_promocion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalles
    ADD CONSTRAINT fk_od_promocion FOREIGN KEY (id_promocion) REFERENCES public.promociones(id_promocion) ON DELETE SET NULL;


--
-- TOC entry 4572 (class 2606 OID 36206)
-- Name: orden_detalles fk_od_zona; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalles
    ADD CONSTRAINT fk_od_zona FOREIGN KEY (id_zona) REFERENCES public.zonas(id_zona);


--
-- TOC entry 4573 (class 2606 OID 36238)
-- Name: orden_detalle_modificadores fk_odm_detalle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalle_modificadores
    ADD CONSTRAINT fk_odm_detalle FOREIGN KEY (id_orden_detalle) REFERENCES public.orden_detalles(id_orden_detalle) ON DELETE CASCADE;


--
-- TOC entry 4574 (class 2606 OID 36243)
-- Name: orden_detalle_modificadores fk_odm_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_detalle_modificadores
    ADD CONSTRAINT fk_odm_ingrediente FOREIGN KEY (id_ingrediente) REFERENCES public.ingredientes(id_ingrediente);


--
-- TOC entry 4575 (class 2606 OID 36263)
-- Name: orden_paquete_selecciones fk_ops_detalle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_paquete_selecciones
    ADD CONSTRAINT fk_ops_detalle FOREIGN KEY (id_orden_detalle) REFERENCES public.orden_detalles(id_orden_detalle) ON DELETE CASCADE;


--
-- TOC entry 4576 (class 2606 OID 36268)
-- Name: orden_paquete_selecciones fk_ops_grupo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_paquete_selecciones
    ADD CONSTRAINT fk_ops_grupo FOREIGN KEY (id_paquete_grupo) REFERENCES public.paquete_grupos(id_paquete_grupo);


--
-- TOC entry 4577 (class 2606 OID 36273)
-- Name: orden_paquete_selecciones fk_ops_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_paquete_selecciones
    ADD CONSTRAINT fk_ops_producto FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto);


--
-- TOC entry 4566 (class 2606 OID 31692)
-- Name: promocion_clientes fk_pc_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_clientes
    ADD CONSTRAINT fk_pc_cliente FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON DELETE CASCADE;


--
-- TOC entry 4567 (class 2606 OID 31687)
-- Name: promocion_clientes fk_pc_promocion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_clientes
    ADD CONSTRAINT fk_pc_promocion FOREIGN KEY (id_promocion) REFERENCES public.promociones(id_promocion) ON DELETE CASCADE;


--
-- TOC entry 4553 (class 2606 OID 22205)
-- Name: producto_ingrediente fk_pi_ingrediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_ingrediente
    ADD CONSTRAINT fk_pi_ingrediente FOREIGN KEY (id_ingrediente) REFERENCES public.ingredientes(id_ingrediente);


--
-- TOC entry 4554 (class 2606 OID 22200)
-- Name: producto_ingrediente fk_pi_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_ingrediente
    ADD CONSTRAINT fk_pi_producto FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto);


--
-- TOC entry 4562 (class 2606 OID 31642)
-- Name: promocion_productos fk_pp_producto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_productos
    ADD CONSTRAINT fk_pp_producto FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 4563 (class 2606 OID 31637)
-- Name: promocion_productos fk_pp_promocion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_productos
    ADD CONSTRAINT fk_pp_promocion FOREIGN KEY (id_promocion) REFERENCES public.promociones(id_promocion) ON DELETE CASCADE;


--
-- TOC entry 4564 (class 2606 OID 31664)
-- Name: promocion_paquetes fk_ppaq_paquete; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_paquetes
    ADD CONSTRAINT fk_ppaq_paquete FOREIGN KEY (id_paquete) REFERENCES public.paquetes(id_paquete) ON DELETE CASCADE;


--
-- TOC entry 4565 (class 2606 OID 31659)
-- Name: promocion_paquetes fk_ppaq_promocion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promocion_paquetes
    ADD CONSTRAINT fk_ppaq_promocion FOREIGN KEY (id_promocion) REFERENCES public.promociones(id_promocion) ON DELETE CASCADE;


--
-- TOC entry 4549 (class 2606 OID 21010)
-- Name: productos fk_producto_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES public.categoria(id_categoria);


--
-- TOC entry 4550 (class 2606 OID 21005)
-- Name: productos fk_producto_zona; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT fk_producto_zona FOREIGN KEY (id_zona) REFERENCES public.zonas(id_zona);


--
-- TOC entry 4555 (class 2606 OID 23383)
-- Name: menu_productos menu_productos_id_menu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_productos
    ADD CONSTRAINT menu_productos_id_menu_fkey FOREIGN KEY (id_menu) REFERENCES public.menus(id_menu) ON DELETE CASCADE;


--
-- TOC entry 4556 (class 2606 OID 23388)
-- Name: menu_productos menu_productos_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_productos
    ADD CONSTRAINT menu_productos_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 4578 (class 2606 OID 36460)
-- Name: orden_pagos orden_pagos_id_orden_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_pagos
    ADD CONSTRAINT orden_pagos_id_orden_fkey FOREIGN KEY (id_orden) REFERENCES public.ordenes(id_orden) ON DELETE CASCADE;


--
-- TOC entry 4579 (class 2606 OID 36465)
-- Name: orden_pagos orden_pagos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_pagos
    ADD CONSTRAINT orden_pagos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- TOC entry 4560 (class 2606 OID 23520)
-- Name: ordenes ordenes_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT ordenes_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON DELETE SET NULL;


--
-- TOC entry 4561 (class 2606 OID 23515)
-- Name: ordenes ordenes_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT ordenes_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- TOC entry 4558 (class 2606 OID 23443)
-- Name: paquete_grupo_productos paquete_grupo_productos_id_paquete_grupo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paquete_grupo_productos
    ADD CONSTRAINT paquete_grupo_productos_id_paquete_grupo_fkey FOREIGN KEY (id_paquete_grupo) REFERENCES public.paquete_grupos(id_paquete_grupo) ON DELETE CASCADE;


--
-- TOC entry 4559 (class 2606 OID 23448)
-- Name: paquete_grupo_productos paquete_grupo_productos_id_producto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paquete_grupo_productos
    ADD CONSTRAINT paquete_grupo_productos_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.productos(id_producto) ON DELETE CASCADE;


--
-- TOC entry 4557 (class 2606 OID 23432)
-- Name: paquete_grupos paquete_grupos_id_paquete_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paquete_grupos
    ADD CONSTRAINT paquete_grupos_id_paquete_fkey FOREIGN KEY (id_paquete) REFERENCES public.paquetes(id_paquete) ON DELETE CASCADE;


--
-- TOC entry 4544 (class 2606 OID 17547)
-- Name: rol_permiso rol_permiso_id_permiso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_id_permiso_fkey FOREIGN KEY (id_permiso) REFERENCES public.permisos(id_permiso);


--
-- TOC entry 4545 (class 2606 OID 17542)
-- Name: rol_permiso rol_permiso_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.roles(id_rol);


--
-- TOC entry 4580 (class 2606 OID 36488)
-- Name: uso_beneficios uso_beneficios_id_cliente_beneficio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uso_beneficios
    ADD CONSTRAINT uso_beneficios_id_cliente_beneficio_fkey FOREIGN KEY (id_cliente_beneficio) REFERENCES public.cliente_beneficio(id_cliente_beneficio);


--
-- TOC entry 4581 (class 2606 OID 36493)
-- Name: uso_beneficios uso_beneficios_id_orden_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uso_beneficios
    ADD CONSTRAINT uso_beneficios_id_orden_fkey FOREIGN KEY (id_orden) REFERENCES public.ordenes(id_orden) ON DELETE CASCADE;


--
-- TOC entry 4546 (class 2606 OID 19796)
-- Name: usuarios usuarios_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.roles(id_rol);


--
-- TOC entry 4539 (class 2606 OID 17333)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4540 (class 2606 OID 17380)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4541 (class 2606 OID 17400)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4542 (class 2606 OID 17395)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4543 (class 2606 OID 17465)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4772 (class 0 OID 16529)
-- Dependencies: 356
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4783 (class 0 OID 16883)
-- Dependencies: 370
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4774 (class 0 OID 16681)
-- Dependencies: 361
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4771 (class 0 OID 16522)
-- Dependencies: 355
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4778 (class 0 OID 16770)
-- Dependencies: 365
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4777 (class 0 OID 16758)
-- Dependencies: 364
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4776 (class 0 OID 16745)
-- Dependencies: 363
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4784 (class 0 OID 16933)
-- Dependencies: 371
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4770 (class 0 OID 16511)
-- Dependencies: 354
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4781 (class 0 OID 16812)
-- Dependencies: 368
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4782 (class 0 OID 16830)
-- Dependencies: 369
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4773 (class 0 OID 16537)
-- Dependencies: 357
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4775 (class 0 OID 16711)
-- Dependencies: 362
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4780 (class 0 OID 16797)
-- Dependencies: 367
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4779 (class 0 OID 16788)
-- Dependencies: 366
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4769 (class 0 OID 16499)
-- Dependencies: 352
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4794 (class 0 OID 41697)
-- Dependencies: 469
-- Name: inventario; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.inventario ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4795 (class 0 OID 41720)
-- Dependencies: 472
-- Name: inventario_movimientos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.inventario_movimientos ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4785 (class 0 OID 17283)
-- Dependencies: 383
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4787 (class 0 OID 17312)
-- Dependencies: 385
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4791 (class 0 OID 17432)
-- Dependencies: 389
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4792 (class 0 OID 17445)
-- Dependencies: 390
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4786 (class 0 OID 17304)
-- Dependencies: 384
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4788 (class 0 OID 17322)
-- Dependencies: 386
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4789 (class 0 OID 17371)
-- Dependencies: 387
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4790 (class 0 OID 17385)
-- Dependencies: 388
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4793 (class 0 OID 17455)
-- Dependencies: 391
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4796 (class 6104 OID 16430)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 33
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 23
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 130
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- TOC entry 4893 (class 0 OID 0)
-- Dependencies: 34
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- TOC entry 4894 (class 0 OID 0)
-- Dependencies: 30
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 670
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 661
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 668
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 675
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 530
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 489
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 586
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 594
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 496
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 512
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 677
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 600
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 616
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 673
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 574
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 656
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 500
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 540
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 666
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 580
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 534
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 528
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 671
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 498
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 546
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 576
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 544
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 550
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 655
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 543
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 619
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 659
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 562
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 583
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 650
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 484
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 504
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 664
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 557
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 552
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 526
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 644
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 649
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 556
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 652
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 648
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 493
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 503
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 564
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 521
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 518
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 607
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 641
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 658
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 603
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 560
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 481
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 633
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 510
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 597
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 502
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 506
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 591
-- Name: FUNCTION actualizar_perfil_usuario(p_id integer, p_nuevo_nombre text, p_nueva_contra text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.actualizar_perfil_usuario(p_id integer, p_nuevo_nombre text, p_nueva_contra text) TO anon;
GRANT ALL ON FUNCTION public.actualizar_perfil_usuario(p_id integer, p_nuevo_nombre text, p_nueva_contra text) TO authenticated;
GRANT ALL ON FUNCTION public.actualizar_perfil_usuario(p_id integer, p_nuevo_nombre text, p_nueva_contra text) TO service_role;


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 647
-- Name: FUNCTION alta_beneficio(p_nombre character varying, p_descripcion text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.alta_beneficio(p_nombre character varying, p_descripcion text) TO anon;
GRANT ALL ON FUNCTION public.alta_beneficio(p_nombre character varying, p_descripcion text) TO authenticated;
GRANT ALL ON FUNCTION public.alta_beneficio(p_nombre character varying, p_descripcion text) TO service_role;


--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 525
-- Name: FUNCTION alta_cliente(p_nombre character varying, p_email character varying, p_telefono character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.alta_cliente(p_nombre character varying, p_email character varying, p_telefono character varying) TO anon;
GRANT ALL ON FUNCTION public.alta_cliente(p_nombre character varying, p_email character varying, p_telefono character varying) TO authenticated;
GRANT ALL ON FUNCTION public.alta_cliente(p_nombre character varying, p_email character varying, p_telefono character varying) TO service_role;


--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 579
-- Name: FUNCTION alta_usuario(p_nombre text, p_contra text, p_rol integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.alta_usuario(p_nombre text, p_contra text, p_rol integer) TO anon;
GRANT ALL ON FUNCTION public.alta_usuario(p_nombre text, p_contra text, p_rol integer) TO authenticated;
GRANT ALL ON FUNCTION public.alta_usuario(p_nombre text, p_contra text, p_rol integer) TO service_role;


--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 514
-- Name: FUNCTION asignar_rfid_cliente(p_id integer, p_rfid character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.asignar_rfid_cliente(p_id integer, p_rfid character varying) TO anon;
GRANT ALL ON FUNCTION public.asignar_rfid_cliente(p_id integer, p_rfid character varying) TO authenticated;
GRANT ALL ON FUNCTION public.asignar_rfid_cliente(p_id integer, p_rfid character varying) TO service_role;


--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 639
-- Name: FUNCTION baja_usuario_por_nombre(p_nombre text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.baja_usuario_por_nombre(p_nombre text) TO anon;
GRANT ALL ON FUNCTION public.baja_usuario_por_nombre(p_nombre text) TO authenticated;
GRANT ALL ON FUNCTION public.baja_usuario_por_nombre(p_nombre text) TO service_role;


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 539
-- Name: FUNCTION fn_actualizar_categoria(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_categoria(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_categoria(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_categoria(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO service_role;


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 538
-- Name: FUNCTION fn_actualizar_cliente_beneficio(p_id integer, p_cantidad_disponible integer, p_cantidad_usada integer, p_fecha_inicio date, p_fecha_fin date, p_dias character varying, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_cliente_beneficio(p_id integer, p_cantidad_disponible integer, p_cantidad_usada integer, p_fecha_inicio date, p_fecha_fin date, p_dias character varying, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_cliente_beneficio(p_id integer, p_cantidad_disponible integer, p_cantidad_usada integer, p_fecha_inicio date, p_fecha_fin date, p_dias character varying, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_cliente_beneficio(p_id integer, p_cantidad_disponible integer, p_cantidad_usada integer, p_fecha_inicio date, p_fecha_fin date, p_dias character varying, p_activo boolean) TO service_role;


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 618
-- Name: FUNCTION fn_actualizar_ingrediente(p_id integer, p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_ingrediente(p_id integer, p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_ingrediente(p_id integer, p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_ingrediente(p_id integer, p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric, p_activo boolean) TO service_role;


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 535
-- Name: FUNCTION fn_actualizar_inventario(p_id_inventario integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_inventario(p_id_inventario integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_inventario(p_id_inventario integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_inventario(p_id_inventario integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying, p_activo boolean) TO service_role;


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 654
-- Name: FUNCTION fn_actualizar_menu(p_id_menu integer, p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_menu(p_id_menu integer, p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_menu(p_id_menu integer, p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_menu(p_id_menu integer, p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date, p_activo boolean) TO service_role;


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 610
-- Name: FUNCTION fn_actualizar_ops(p_id integer, p_cantidad integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_ops(p_id integer, p_cantidad integer) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_ops(p_id integer, p_cantidad integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_ops(p_id integer, p_cantidad integer) TO service_role;


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 509
-- Name: FUNCTION fn_actualizar_orden(p_id integer, p_estado_orden public.estado_orden_enum, p_estado_pago public.estado_pago_enum, p_metodo_pago public.metodo_pago_enum, p_descuento numeric, p_impuestos numeric, p_total numeric, p_notas text, p_fecha_entrega timestamp without time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_orden(p_id integer, p_estado_orden public.estado_orden_enum, p_estado_pago public.estado_pago_enum, p_metodo_pago public.metodo_pago_enum, p_descuento numeric, p_impuestos numeric, p_total numeric, p_notas text, p_fecha_entrega timestamp without time zone) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_orden(p_id integer, p_estado_orden public.estado_orden_enum, p_estado_pago public.estado_pago_enum, p_metodo_pago public.metodo_pago_enum, p_descuento numeric, p_impuestos numeric, p_total numeric, p_notas text, p_fecha_entrega timestamp without time zone) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_orden(p_id integer, p_estado_orden public.estado_orden_enum, p_estado_pago public.estado_pago_enum, p_metodo_pago public.metodo_pago_enum, p_descuento numeric, p_impuestos numeric, p_total numeric, p_notas text, p_fecha_entrega timestamp without time zone) TO service_role;


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 532
-- Name: FUNCTION fn_actualizar_orden_detalle(p_id integer, p_cantidad integer, p_precio_unitario numeric, p_descuento numeric, p_subtotal numeric, p_estado public.estado_preparacion_enum, p_notas text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_orden_detalle(p_id integer, p_cantidad integer, p_precio_unitario numeric, p_descuento numeric, p_subtotal numeric, p_estado public.estado_preparacion_enum, p_notas text) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_orden_detalle(p_id integer, p_cantidad integer, p_precio_unitario numeric, p_descuento numeric, p_subtotal numeric, p_estado public.estado_preparacion_enum, p_notas text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_orden_detalle(p_id integer, p_cantidad integer, p_precio_unitario numeric, p_descuento numeric, p_subtotal numeric, p_estado public.estado_preparacion_enum, p_notas text) TO service_role;


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 561
-- Name: FUNCTION fn_actualizar_orden_modificador(p_id integer, p_accion public.accion_modificador_enum, p_precio numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_orden_modificador(p_id integer, p_accion public.accion_modificador_enum, p_precio numeric) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_orden_modificador(p_id integer, p_accion public.accion_modificador_enum, p_precio numeric) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_orden_modificador(p_id integer, p_accion public.accion_modificador_enum, p_precio numeric) TO service_role;


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 657
-- Name: FUNCTION fn_actualizar_pago(p_id_pago integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_pago(p_id_pago integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_pago(p_id_pago integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_pago(p_id_pago integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer, p_activo boolean) TO service_role;


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 665
-- Name: FUNCTION fn_actualizar_paquete(p_id_paquete integer, p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_paquete(p_id_paquete integer, p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_paquete(p_id_paquete integer, p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_paquete(p_id_paquete integer, p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text, p_activo boolean) TO service_role;


--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 572
-- Name: FUNCTION fn_actualizar_paquete_grupo(p_id integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_paquete_grupo(p_id integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_paquete_grupo(p_id integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_paquete_grupo(p_id integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer, p_activo boolean) TO service_role;


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 537
-- Name: FUNCTION fn_actualizar_paquete_grupo_productos(p_id_grupo integer, p_id_producto integer, p_precio numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_paquete_grupo_productos(p_id_grupo integer, p_id_producto integer, p_precio numeric) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_paquete_grupo_productos(p_id_grupo integer, p_id_producto integer, p_precio numeric) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_paquete_grupo_productos(p_id_grupo integer, p_id_producto integer, p_precio numeric) TO service_role;


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 630
-- Name: FUNCTION fn_actualizar_precio_extra(p_id_grupo integer, p_id_producto integer, p_precio numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_precio_extra(p_id_grupo integer, p_id_producto integer, p_precio numeric) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_precio_extra(p_id_grupo integer, p_id_producto integer, p_precio numeric) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_precio_extra(p_id_grupo integer, p_id_producto integer, p_precio numeric) TO service_role;


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 559
-- Name: FUNCTION fn_actualizar_producto(p_id_producto integer, p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text, p_disponibilidad boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_producto(p_id_producto integer, p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text, p_disponibilidad boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_producto(p_id_producto integer, p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text, p_disponibilidad boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_producto(p_id_producto integer, p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text, p_disponibilidad boolean) TO service_role;


--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 497
-- Name: FUNCTION fn_actualizar_producto_ingrediente(p_id integer, p_es_obligatorio boolean, p_precio numeric, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_producto_ingrediente(p_id integer, p_es_obligatorio boolean, p_precio numeric, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_producto_ingrediente(p_id integer, p_es_obligatorio boolean, p_precio numeric, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_producto_ingrediente(p_id integer, p_es_obligatorio boolean, p_precio numeric, p_activo boolean) TO service_role;


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 558
-- Name: FUNCTION fn_actualizar_promocion(p_id integer, p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_promocion(p_id integer, p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_promocion(p_id integer, p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_promocion(p_id integer, p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean, p_activo boolean) TO service_role;


--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 636
-- Name: FUNCTION fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text) TO service_role;


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 505
-- Name: FUNCTION fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_tipo_beneficio(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO service_role;


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 520
-- Name: FUNCTION fn_actualizar_uso_beneficio(p_id_uso_beneficio integer, p_cantidad integer, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_uso_beneficio(p_id_uso_beneficio integer, p_cantidad integer, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_uso_beneficio(p_id_uso_beneficio integer, p_cantidad integer, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_uso_beneficio(p_id_uso_beneficio integer, p_cantidad integer, p_activo boolean) TO service_role;


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 662
-- Name: FUNCTION fn_actualizar_zona(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_actualizar_zona(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_actualizar_zona(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_actualizar_zona(p_id integer, p_nombre character varying, p_descripcion text, p_activo boolean) TO service_role;


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 640
-- Name: FUNCTION fn_alta_categoria(p_nombre character varying, p_descripcion text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_categoria(p_nombre character varying, p_descripcion text) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_categoria(p_nombre character varying, p_descripcion text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_categoria(p_nombre character varying, p_descripcion text) TO service_role;


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 614
-- Name: FUNCTION fn_alta_cliente_beneficio(p_id_cliente integer, p_id_tipo_beneficio integer, p_fecha_inicio date, p_cantidad integer, p_fecha_fin date, p_dias character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_cliente_beneficio(p_id_cliente integer, p_id_tipo_beneficio integer, p_fecha_inicio date, p_cantidad integer, p_fecha_fin date, p_dias character varying) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_cliente_beneficio(p_id_cliente integer, p_id_tipo_beneficio integer, p_fecha_inicio date, p_cantidad integer, p_fecha_fin date, p_dias character varying) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_cliente_beneficio(p_id_cliente integer, p_id_tipo_beneficio integer, p_fecha_inicio date, p_cantidad integer, p_fecha_fin date, p_dias character varying) TO service_role;


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 541
-- Name: FUNCTION fn_alta_ingrediente(p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_ingrediente(p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_ingrediente(p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_ingrediente(p_nombre character varying, p_tipo public.tipo_ingrediente_enum, p_precio numeric) TO service_role;


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 631
-- Name: FUNCTION fn_alta_inventario(p_id_ingrediente integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_inventario(p_id_ingrediente integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_inventario(p_id_ingrediente integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_inventario(p_id_ingrediente integer, p_cantidad_actual numeric, p_cantidad_minima numeric, p_unidad character varying) TO service_role;


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 595
-- Name: FUNCTION fn_alta_menu(p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_menu(p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_menu(p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_menu(p_nombre_menu character varying, p_descripcion text, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias_semana character varying, p_fecha_inicio date, p_fecha_fin date) TO service_role;


--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 553
-- Name: FUNCTION fn_alta_menu_producto(p_id_menu integer, p_id_producto integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_menu_producto(p_id_menu integer, p_id_producto integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_menu_producto(p_id_menu integer, p_id_producto integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_menu_producto(p_id_menu integer, p_id_producto integer) TO service_role;


--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 569
-- Name: FUNCTION fn_alta_movimiento(p_id_inventario integer, p_tipo_movimiento character varying, p_cantidad numeric, p_motivo text, p_id_usuario integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_movimiento(p_id_inventario integer, p_tipo_movimiento character varying, p_cantidad numeric, p_motivo text, p_id_usuario integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_movimiento(p_id_inventario integer, p_tipo_movimiento character varying, p_cantidad numeric, p_motivo text, p_id_usuario integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_movimiento(p_id_inventario integer, p_tipo_movimiento character varying, p_cantidad numeric, p_motivo text, p_id_usuario integer) TO service_role;


--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 511
-- Name: FUNCTION fn_alta_ops(p_id_detalle integer, p_id_grupo integer, p_id_producto integer, p_cantidad integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_ops(p_id_detalle integer, p_id_grupo integer, p_id_producto integer, p_cantidad integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_ops(p_id_detalle integer, p_id_grupo integer, p_id_producto integer, p_cantidad integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_ops(p_id_detalle integer, p_id_grupo integer, p_id_producto integer, p_cantidad integer) TO service_role;


--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 674
-- Name: FUNCTION fn_alta_orden(p_numero_orden character varying, p_id_usuario integer, p_subtotal numeric, p_total numeric, p_id_cliente integer, p_tipo_orden public.tipo_orden_enum, p_mesa_numero character varying, p_descuento numeric, p_impuestos numeric, p_notas text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_orden(p_numero_orden character varying, p_id_usuario integer, p_subtotal numeric, p_total numeric, p_id_cliente integer, p_tipo_orden public.tipo_orden_enum, p_mesa_numero character varying, p_descuento numeric, p_impuestos numeric, p_notas text) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_orden(p_numero_orden character varying, p_id_usuario integer, p_subtotal numeric, p_total numeric, p_id_cliente integer, p_tipo_orden public.tipo_orden_enum, p_mesa_numero character varying, p_descuento numeric, p_impuestos numeric, p_notas text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_orden(p_numero_orden character varying, p_id_usuario integer, p_subtotal numeric, p_total numeric, p_id_cliente integer, p_tipo_orden public.tipo_orden_enum, p_mesa_numero character varying, p_descuento numeric, p_impuestos numeric, p_notas text) TO service_role;


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 533
-- Name: FUNCTION fn_alta_orden_detalle(p_id_orden integer, p_cantidad integer, p_precio_unitario numeric, p_subtotal numeric, p_id_producto integer, p_id_paquete integer, p_descuento numeric, p_id_promocion integer, p_id_zona integer, p_notas text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_orden_detalle(p_id_orden integer, p_cantidad integer, p_precio_unitario numeric, p_subtotal numeric, p_id_producto integer, p_id_paquete integer, p_descuento numeric, p_id_promocion integer, p_id_zona integer, p_notas text) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_orden_detalle(p_id_orden integer, p_cantidad integer, p_precio_unitario numeric, p_subtotal numeric, p_id_producto integer, p_id_paquete integer, p_descuento numeric, p_id_promocion integer, p_id_zona integer, p_notas text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_orden_detalle(p_id_orden integer, p_cantidad integer, p_precio_unitario numeric, p_subtotal numeric, p_id_producto integer, p_id_paquete integer, p_descuento numeric, p_id_promocion integer, p_id_zona integer, p_notas text) TO service_role;


--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 623
-- Name: FUNCTION fn_alta_orden_modifica(p_id_detalle integer, p_id_ingrediente integer, p_accion public.accion_modificador_enum, p_precio numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_orden_modifica(p_id_detalle integer, p_id_ingrediente integer, p_accion public.accion_modificador_enum, p_precio numeric) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_orden_modifica(p_id_detalle integer, p_id_ingrediente integer, p_accion public.accion_modificador_enum, p_precio numeric) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_orden_modifica(p_id_detalle integer, p_id_ingrediente integer, p_accion public.accion_modificador_enum, p_precio numeric) TO service_role;


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 590
-- Name: FUNCTION fn_alta_pago(p_id_orden integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_pago(p_id_orden integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_pago(p_id_orden integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_pago(p_id_orden integer, p_metodo_pago public.metodo_pago_enum, p_monto numeric, p_referencia character varying, p_id_usuario integer) TO service_role;


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 517
-- Name: FUNCTION fn_alta_paquete(p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_paquete(p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_paquete(p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_paquete(p_nombre_paquete character varying, p_descripcion text, p_precio_paquete numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_dias_disponibles character varying, p_url_imagen text) TO service_role;


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 529
-- Name: FUNCTION fn_alta_paquete_grupo(p_id_paquete integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_paquete_grupo(p_id_paquete integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_paquete_grupo(p_id_paquete integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_paquete_grupo(p_id_paquete integer, p_nombre_grupo character varying, p_seleccion_obligatoria boolean, p_cantidad_selecciones integer) TO service_role;


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 482
-- Name: FUNCTION fn_alta_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer, p_precio_adicional numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer, p_precio_adicional numeric) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer, p_precio_adicional numeric) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer, p_precio_adicional numeric) TO service_role;


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 577
-- Name: FUNCTION fn_alta_permiso(p_nombre_permiso character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_permiso(p_nombre_permiso character varying) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_permiso(p_nombre_permiso character varying) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_permiso(p_nombre_permiso character varying) TO service_role;


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 663
-- Name: FUNCTION fn_alta_producto(p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_producto(p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_producto(p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_producto(p_nombre_producto character varying, p_descripcion text, p_precio_base numeric, p_id_zona integer, p_id_categoria integer, p_url_imagen text) TO service_role;


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 575
-- Name: FUNCTION fn_alta_producto_ingrediente(p_id_producto integer, p_id_ingrediente integer, p_es_obligatorio boolean, p_precio numeric); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_producto_ingrediente(p_id_producto integer, p_id_ingrediente integer, p_es_obligatorio boolean, p_precio numeric) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_producto_ingrediente(p_id_producto integer, p_id_ingrediente integer, p_es_obligatorio boolean, p_precio numeric) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_producto_ingrediente(p_id_producto integer, p_id_ingrediente integer, p_es_obligatorio boolean, p_precio numeric) TO service_role;


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 602
-- Name: FUNCTION fn_alta_promocion(p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_promocion(p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_promocion(p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_promocion(p_nombre character varying, p_descripcion text, p_tipo public.tipo_promocion_enum, p_valor numeric, p_es_temporal boolean, p_fecha_inicio timestamp without time zone, p_fecha_fin timestamp without time zone, p_hora_inicio time without time zone, p_hora_fin time without time zone, p_dias text[], p_es_permanente boolean, p_solo_clientes boolean) TO service_role;


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 548
-- Name: FUNCTION fn_alta_promocion_cliente(p_id_promocion integer, p_id_cliente integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_promocion_cliente(p_id_promocion integer, p_id_cliente integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_promocion_cliente(p_id_promocion integer, p_id_cliente integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_promocion_cliente(p_id_promocion integer, p_id_cliente integer) TO service_role;


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 629
-- Name: FUNCTION fn_alta_promocion_paquete(p_id_promocion integer, p_id_paquete integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_promocion_paquete(p_id_promocion integer, p_id_paquete integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_promocion_paquete(p_id_promocion integer, p_id_paquete integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_promocion_paquete(p_id_promocion integer, p_id_paquete integer) TO service_role;


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 669
-- Name: FUNCTION fn_alta_promocion_producto(p_id_promocion integer, p_id_producto integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_promocion_producto(p_id_promocion integer, p_id_producto integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_promocion_producto(p_id_promocion integer, p_id_producto integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_promocion_producto(p_id_promocion integer, p_id_producto integer) TO service_role;


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 549
-- Name: FUNCTION fn_alta_rol(p_nombre_rol character varying, p_descripcion character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_rol(p_nombre_rol character varying, p_descripcion character varying) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_rol(p_nombre_rol character varying, p_descripcion character varying) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_rol(p_nombre_rol character varying, p_descripcion character varying) TO service_role;


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 536
-- Name: FUNCTION fn_alta_tipo_beneficio(p_nombre character varying, p_descripcion text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_tipo_beneficio(p_nombre character varying, p_descripcion text) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_tipo_beneficio(p_nombre character varying, p_descripcion text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_tipo_beneficio(p_nombre character varying, p_descripcion text) TO service_role;


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 551
-- Name: FUNCTION fn_alta_uso_beneficio(p_id_cliente_beneficio integer, p_id_orden integer, p_cantidad integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_uso_beneficio(p_id_cliente_beneficio integer, p_id_orden integer, p_cantidad integer) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_uso_beneficio(p_id_cliente_beneficio integer, p_id_orden integer, p_cantidad integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_uso_beneficio(p_id_cliente_beneficio integer, p_id_orden integer, p_cantidad integer) TO service_role;


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 596
-- Name: FUNCTION fn_alta_zona(p_nombre character varying, p_descripcion text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_alta_zona(p_nombre character varying, p_descripcion text) TO anon;
GRANT ALL ON FUNCTION public.fn_alta_zona(p_nombre character varying, p_descripcion text) TO authenticated;
GRANT ALL ON FUNCTION public.fn_alta_zona(p_nombre character varying, p_descripcion text) TO service_role;


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 624
-- Name: FUNCTION fn_asignar_permiso(p_id_rol integer, p_id_permiso integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_asignar_permiso(p_id_rol integer, p_id_permiso integer) TO anon;
GRANT ALL ON FUNCTION public.fn_asignar_permiso(p_id_rol integer, p_id_permiso integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_asignar_permiso(p_id_rol integer, p_id_permiso integer) TO service_role;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 634
-- Name: FUNCTION fn_baja_categoria(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_categoria(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_categoria(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_categoria(p_id integer) TO service_role;


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 646
-- Name: FUNCTION fn_baja_cliente_beneficio(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_cliente_beneficio(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_cliente_beneficio(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_cliente_beneficio(p_id integer) TO service_role;


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 545
-- Name: FUNCTION fn_baja_ingrediente(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_ingrediente(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_ingrediente(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_ingrediente(p_id integer) TO service_role;


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 578
-- Name: FUNCTION fn_baja_inventario(p_id_inventario integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_inventario(p_id_inventario integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_inventario(p_id_inventario integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_inventario(p_id_inventario integer) TO service_role;


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 490
-- Name: FUNCTION fn_baja_menu(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_menu(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_menu(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_menu(p_id integer) TO service_role;


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 598
-- Name: FUNCTION fn_baja_ops(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_ops(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_ops(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_ops(p_id integer) TO service_role;


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 492
-- Name: FUNCTION fn_baja_orden(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_orden(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_orden(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_orden(p_id integer) TO service_role;


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 589
-- Name: FUNCTION fn_baja_orden_detalle(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_orden_detalle(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_orden_detalle(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_orden_detalle(p_id integer) TO service_role;


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 599
-- Name: FUNCTION fn_baja_orden_modificador(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_orden_modificador(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_orden_modificador(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_orden_modificador(p_id integer) TO service_role;


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 483
-- Name: FUNCTION fn_baja_pago(p_id_pago integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_pago(p_id_pago integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_pago(p_id_pago integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_pago(p_id_pago integer) TO service_role;


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 672
-- Name: FUNCTION fn_baja_paquete(p_id_paquete integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_paquete(p_id_paquete integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_paquete(p_id_paquete integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_paquete(p_id_paquete integer) TO service_role;


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 527
-- Name: FUNCTION fn_baja_paquete_grupo(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_paquete_grupo(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_paquete_grupo(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_paquete_grupo(p_id integer) TO service_role;


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 588
-- Name: FUNCTION fn_baja_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_paquete_grupo_producto(p_id_grupo integer, p_id_producto integer) TO service_role;


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 637
-- Name: FUNCTION fn_baja_permiso(p_id_permiso integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_permiso(p_id_permiso integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_permiso(p_id_permiso integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_permiso(p_id_permiso integer) TO service_role;


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 653
-- Name: FUNCTION fn_baja_producto(p_id_producto integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_producto(p_id_producto integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_producto(p_id_producto integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_producto(p_id_producto integer) TO service_role;


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 645
-- Name: FUNCTION fn_baja_producto_ingrediente(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_producto_ingrediente(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_producto_ingrediente(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_producto_ingrediente(p_id integer) TO service_role;


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 524
-- Name: FUNCTION fn_baja_promocion(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_promocion(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_promocion(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_promocion(p_id integer) TO service_role;


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 487
-- Name: FUNCTION fn_baja_promocion_cliente(p_id_promocion integer, p_id_cliente integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_promocion_cliente(p_id_promocion integer, p_id_cliente integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_promocion_cliente(p_id_promocion integer, p_id_cliente integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_promocion_cliente(p_id_promocion integer, p_id_cliente integer) TO service_role;


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 516
-- Name: FUNCTION fn_baja_promocion_paquete(p_id_promocion integer, p_id_paquete integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_promocion_paquete(p_id_promocion integer, p_id_paquete integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_promocion_paquete(p_id_promocion integer, p_id_paquete integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_promocion_paquete(p_id_promocion integer, p_id_paquete integer) TO service_role;


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 478
-- Name: FUNCTION fn_baja_promocion_producto(p_id_promocion integer, p_id_producto integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_promocion_producto(p_id_promocion integer, p_id_producto integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_promocion_producto(p_id_promocion integer, p_id_producto integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_promocion_producto(p_id_promocion integer, p_id_producto integer) TO service_role;


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 635
-- Name: FUNCTION fn_baja_rol(p_id_rol integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_rol(p_id_rol integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_rol(p_id_rol integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_rol(p_id_rol integer) TO service_role;


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 601
-- Name: FUNCTION fn_baja_tipo_beneficio(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_tipo_beneficio(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_tipo_beneficio(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_tipo_beneficio(p_id integer) TO service_role;


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 567
-- Name: FUNCTION fn_baja_uso_beneficio(p_id_uso_beneficio integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_uso_beneficio(p_id_uso_beneficio integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_uso_beneficio(p_id_uso_beneficio integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_uso_beneficio(p_id_uso_beneficio integer) TO service_role;


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 542
-- Name: FUNCTION fn_baja_zona(p_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_baja_zona(p_id integer) TO anon;
GRANT ALL ON FUNCTION public.fn_baja_zona(p_id integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_baja_zona(p_id integer) TO service_role;


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 605
-- Name: FUNCTION fn_cambiar_permiso(p_id_rol integer, p_id_permiso_viejo integer, p_id_permiso_nuevo integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_cambiar_permiso(p_id_rol integer, p_id_permiso_viejo integer, p_id_permiso_nuevo integer) TO anon;
GRANT ALL ON FUNCTION public.fn_cambiar_permiso(p_id_rol integer, p_id_permiso_viejo integer, p_id_permiso_nuevo integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_cambiar_permiso(p_id_rol integer, p_id_permiso_viejo integer, p_id_permiso_nuevo integer) TO service_role;


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 565
-- Name: FUNCTION fn_editar_permiso(p_id_permiso integer, p_nombre_permiso character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_editar_permiso(p_id_permiso integer, p_nombre_permiso character varying) TO anon;
GRANT ALL ON FUNCTION public.fn_editar_permiso(p_id_permiso integer, p_nombre_permiso character varying) TO authenticated;
GRANT ALL ON FUNCTION public.fn_editar_permiso(p_id_permiso integer, p_nombre_permiso character varying) TO service_role;


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 499
-- Name: FUNCTION fn_editar_rol(p_id_rol integer, p_nombre_rol character varying, p_descripcion character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_editar_rol(p_id_rol integer, p_nombre_rol character varying, p_descripcion character varying) TO anon;
GRANT ALL ON FUNCTION public.fn_editar_rol(p_id_rol integer, p_nombre_rol character varying, p_descripcion character varying) TO authenticated;
GRANT ALL ON FUNCTION public.fn_editar_rol(p_id_rol integer, p_nombre_rol character varying, p_descripcion character varying) TO service_role;


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 570
-- Name: FUNCTION fn_eliminar_menu_producto(p_id_menu integer, p_id_producto integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_eliminar_menu_producto(p_id_menu integer, p_id_producto integer) TO anon;
GRANT ALL ON FUNCTION public.fn_eliminar_menu_producto(p_id_menu integer, p_id_producto integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_eliminar_menu_producto(p_id_menu integer, p_id_producto integer) TO service_role;


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 604
-- Name: FUNCTION fn_get_grupos_por_paquete(p_id_paquete integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_get_grupos_por_paquete(p_id_paquete integer) TO anon;
GRANT ALL ON FUNCTION public.fn_get_grupos_por_paquete(p_id_paquete integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_get_grupos_por_paquete(p_id_paquete integer) TO service_role;


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 507
-- Name: FUNCTION fn_get_ingredientes_de_producto(p_id_producto integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_get_ingredientes_de_producto(p_id_producto integer) TO anon;
GRANT ALL ON FUNCTION public.fn_get_ingredientes_de_producto(p_id_producto integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_get_ingredientes_de_producto(p_id_producto integer) TO service_role;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 621
-- Name: FUNCTION fn_get_menu_paquetes_completo(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_get_menu_paquetes_completo() TO anon;
GRANT ALL ON FUNCTION public.fn_get_menu_paquetes_completo() TO authenticated;
GRANT ALL ON FUNCTION public.fn_get_menu_paquetes_completo() TO service_role;


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 566
-- Name: FUNCTION fn_get_productos_por_menu(p_id_menu integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_get_productos_por_menu(p_id_menu integer) TO anon;
GRANT ALL ON FUNCTION public.fn_get_productos_por_menu(p_id_menu integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_get_productos_por_menu(p_id_menu integer) TO service_role;


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 513
-- Name: FUNCTION fn_quitar_permiso(p_id_rol integer, p_id_permiso integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fn_quitar_permiso(p_id_rol integer, p_id_permiso integer) TO anon;
GRANT ALL ON FUNCTION public.fn_quitar_permiso(p_id_rol integer, p_id_permiso integer) TO authenticated;
GRANT ALL ON FUNCTION public.fn_quitar_permiso(p_id_rol integer, p_id_permiso integer) TO service_role;


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 486
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 554
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 617
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 638
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 519
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 582
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 626
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 491
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 587
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 495
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 593
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 501
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 625
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 620
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 642
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 370
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 373
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 375
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 374
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 371
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 353
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 352
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 414
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 413
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 406
-- Name: TABLE categoria; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categoria TO anon;
GRANT ALL ON TABLE public.categoria TO authenticated;
GRANT ALL ON TABLE public.categoria TO service_role;


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 405
-- Name: SEQUENCE categoria_id_categoria_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.categoria_id_categoria_seq TO anon;
GRANT ALL ON SEQUENCE public.categoria_id_categoria_seq TO authenticated;
GRANT ALL ON SEQUENCE public.categoria_id_categoria_seq TO service_role;


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 404
-- Name: TABLE cliente_beneficio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cliente_beneficio TO anon;
GRANT ALL ON TABLE public.cliente_beneficio TO authenticated;
GRANT ALL ON TABLE public.cliente_beneficio TO service_role;


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 403
-- Name: SEQUENCE cliente_beneficio_id_cliente_beneficio_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cliente_beneficio_id_cliente_beneficio_seq TO anon;
GRANT ALL ON SEQUENCE public.cliente_beneficio_id_cliente_beneficio_seq TO authenticated;
GRANT ALL ON SEQUENCE public.cliente_beneficio_id_cliente_beneficio_seq TO service_role;


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE clientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.clientes TO anon;
GRANT ALL ON TABLE public.clientes TO authenticated;
GRANT ALL ON TABLE public.clientes TO service_role;


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 399
-- Name: SEQUENCE clientes_id_cliente_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.clientes_id_cliente_seq TO anon;
GRANT ALL ON SEQUENCE public.clientes_id_cliente_seq TO authenticated;
GRANT ALL ON SEQUENCE public.clientes_id_cliente_seq TO service_role;


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 416
-- Name: TABLE ingredientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ingredientes TO anon;
GRANT ALL ON TABLE public.ingredientes TO authenticated;
GRANT ALL ON TABLE public.ingredientes TO service_role;


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 415
-- Name: SEQUENCE ingredientes_id_ingrediente_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ingredientes_id_ingrediente_seq TO anon;
GRANT ALL ON SEQUENCE public.ingredientes_id_ingrediente_seq TO authenticated;
GRANT ALL ON SEQUENCE public.ingredientes_id_ingrediente_seq TO service_role;


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 469
-- Name: TABLE inventario; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventario TO anon;
GRANT ALL ON TABLE public.inventario TO authenticated;
GRANT ALL ON TABLE public.inventario TO service_role;


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 468
-- Name: SEQUENCE inventario_id_inventario_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventario_id_inventario_seq TO anon;
GRANT ALL ON SEQUENCE public.inventario_id_inventario_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventario_id_inventario_seq TO service_role;


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 472
-- Name: TABLE inventario_movimientos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inventario_movimientos TO anon;
GRANT ALL ON TABLE public.inventario_movimientos TO authenticated;
GRANT ALL ON TABLE public.inventario_movimientos TO service_role;


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 471
-- Name: SEQUENCE inventario_movimientos_id_movimiento_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inventario_movimientos_id_movimiento_seq TO anon;
GRANT ALL ON SEQUENCE public.inventario_movimientos_id_movimiento_seq TO authenticated;
GRANT ALL ON SEQUENCE public.inventario_movimientos_id_movimiento_seq TO service_role;


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 422
-- Name: TABLE menu_productos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.menu_productos TO anon;
GRANT ALL ON TABLE public.menu_productos TO authenticated;
GRANT ALL ON TABLE public.menu_productos TO service_role;


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 421
-- Name: TABLE menus; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.menus TO anon;
GRANT ALL ON TABLE public.menus TO authenticated;
GRANT ALL ON TABLE public.menus TO service_role;


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 420
-- Name: SEQUENCE menus_id_menu_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.menus_id_menu_seq TO anon;
GRANT ALL ON SEQUENCE public.menus_id_menu_seq TO authenticated;
GRANT ALL ON SEQUENCE public.menus_id_menu_seq TO service_role;


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 456
-- Name: TABLE orden_detalle_modificadores; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.orden_detalle_modificadores TO anon;
GRANT ALL ON TABLE public.orden_detalle_modificadores TO authenticated;
GRANT ALL ON TABLE public.orden_detalle_modificadores TO service_role;


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 455
-- Name: SEQUENCE orden_detalle_modificadores_id_detalle_modificador_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.orden_detalle_modificadores_id_detalle_modificador_seq TO anon;
GRANT ALL ON SEQUENCE public.orden_detalle_modificadores_id_detalle_modificador_seq TO authenticated;
GRANT ALL ON SEQUENCE public.orden_detalle_modificadores_id_detalle_modificador_seq TO service_role;


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 452
-- Name: TABLE orden_detalles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.orden_detalles TO anon;
GRANT ALL ON TABLE public.orden_detalles TO authenticated;
GRANT ALL ON TABLE public.orden_detalles TO service_role;


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 451
-- Name: SEQUENCE orden_detalles_id_orden_detalle_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.orden_detalles_id_orden_detalle_seq TO anon;
GRANT ALL ON SEQUENCE public.orden_detalles_id_orden_detalle_seq TO authenticated;
GRANT ALL ON SEQUENCE public.orden_detalles_id_orden_detalle_seq TO service_role;


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 461
-- Name: TABLE orden_pagos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.orden_pagos TO anon;
GRANT ALL ON TABLE public.orden_pagos TO authenticated;
GRANT ALL ON TABLE public.orden_pagos TO service_role;


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 460
-- Name: SEQUENCE orden_pagos_id_pago_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.orden_pagos_id_pago_seq TO anon;
GRANT ALL ON SEQUENCE public.orden_pagos_id_pago_seq TO authenticated;
GRANT ALL ON SEQUENCE public.orden_pagos_id_pago_seq TO service_role;


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 459
-- Name: TABLE orden_paquete_selecciones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.orden_paquete_selecciones TO anon;
GRANT ALL ON TABLE public.orden_paquete_selecciones TO authenticated;
GRANT ALL ON TABLE public.orden_paquete_selecciones TO service_role;


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 458
-- Name: SEQUENCE orden_paquete_selecciones_id_seleccion_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.orden_paquete_selecciones_id_seleccion_seq TO anon;
GRANT ALL ON SEQUENCE public.orden_paquete_selecciones_id_seleccion_seq TO authenticated;
GRANT ALL ON SEQUENCE public.orden_paquete_selecciones_id_seleccion_seq TO service_role;


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 430
-- Name: TABLE ordenes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ordenes TO anon;
GRANT ALL ON TABLE public.ordenes TO authenticated;
GRANT ALL ON TABLE public.ordenes TO service_role;


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 429
-- Name: SEQUENCE ordenes_id_orden_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ordenes_id_orden_seq TO anon;
GRANT ALL ON SEQUENCE public.ordenes_id_orden_seq TO authenticated;
GRANT ALL ON SEQUENCE public.ordenes_id_orden_seq TO service_role;


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 427
-- Name: TABLE paquete_grupo_productos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.paquete_grupo_productos TO anon;
GRANT ALL ON TABLE public.paquete_grupo_productos TO authenticated;
GRANT ALL ON TABLE public.paquete_grupo_productos TO service_role;


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 426
-- Name: TABLE paquete_grupos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.paquete_grupos TO anon;
GRANT ALL ON TABLE public.paquete_grupos TO authenticated;
GRANT ALL ON TABLE public.paquete_grupos TO service_role;


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 425
-- Name: SEQUENCE paquete_grupos_id_paquete_grupo_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.paquete_grupos_id_paquete_grupo_seq TO anon;
GRANT ALL ON SEQUENCE public.paquete_grupos_id_paquete_grupo_seq TO authenticated;
GRANT ALL ON SEQUENCE public.paquete_grupos_id_paquete_grupo_seq TO service_role;


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 424
-- Name: TABLE paquetes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.paquetes TO anon;
GRANT ALL ON TABLE public.paquetes TO authenticated;
GRANT ALL ON TABLE public.paquetes TO service_role;


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 423
-- Name: SEQUENCE paquetes_id_paquete_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.paquetes_id_paquete_seq TO anon;
GRANT ALL ON SEQUENCE public.paquetes_id_paquete_seq TO authenticated;
GRANT ALL ON SEQUENCE public.paquetes_id_paquete_seq TO service_role;


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 395
-- Name: TABLE permisos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.permisos TO anon;
GRANT ALL ON TABLE public.permisos TO authenticated;
GRANT ALL ON TABLE public.permisos TO service_role;


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 394
-- Name: SEQUENCE permisos_id_permiso_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.permisos_id_permiso_seq TO anon;
GRANT ALL ON SEQUENCE public.permisos_id_permiso_seq TO authenticated;
GRANT ALL ON SEQUENCE public.permisos_id_permiso_seq TO service_role;


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 418
-- Name: TABLE producto_ingrediente; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.producto_ingrediente TO anon;
GRANT ALL ON TABLE public.producto_ingrediente TO authenticated;
GRANT ALL ON TABLE public.producto_ingrediente TO service_role;


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 417
-- Name: SEQUENCE producto_ingrediente_id_producto_ingrediente_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.producto_ingrediente_id_producto_ingrediente_seq TO anon;
GRANT ALL ON SEQUENCE public.producto_ingrediente_id_producto_ingrediente_seq TO authenticated;
GRANT ALL ON SEQUENCE public.producto_ingrediente_id_producto_ingrediente_seq TO service_role;


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 412
-- Name: TABLE productos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.productos TO anon;
GRANT ALL ON TABLE public.productos TO authenticated;
GRANT ALL ON TABLE public.productos TO service_role;


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 411
-- Name: SEQUENCE productos_id_producto_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.productos_id_producto_seq TO anon;
GRANT ALL ON SEQUENCE public.productos_id_producto_seq TO authenticated;
GRANT ALL ON SEQUENCE public.productos_id_producto_seq TO service_role;


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 448
-- Name: TABLE promocion_clientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.promocion_clientes TO anon;
GRANT ALL ON TABLE public.promocion_clientes TO authenticated;
GRANT ALL ON TABLE public.promocion_clientes TO service_role;


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 446
-- Name: TABLE promocion_paquetes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.promocion_paquetes TO anon;
GRANT ALL ON TABLE public.promocion_paquetes TO authenticated;
GRANT ALL ON TABLE public.promocion_paquetes TO service_role;


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 444
-- Name: TABLE promocion_productos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.promocion_productos TO anon;
GRANT ALL ON TABLE public.promocion_productos TO authenticated;
GRANT ALL ON TABLE public.promocion_productos TO service_role;


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 443
-- Name: TABLE promociones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.promociones TO anon;
GRANT ALL ON TABLE public.promociones TO authenticated;
GRANT ALL ON TABLE public.promociones TO service_role;


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 442
-- Name: SEQUENCE promociones_id_promocion_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.promociones_id_promocion_seq TO anon;
GRANT ALL ON SEQUENCE public.promociones_id_promocion_seq TO authenticated;
GRANT ALL ON SEQUENCE public.promociones_id_promocion_seq TO service_role;


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 396
-- Name: TABLE rol_permiso; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rol_permiso TO anon;
GRANT ALL ON TABLE public.rol_permiso TO authenticated;
GRANT ALL ON TABLE public.rol_permiso TO service_role;


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 393
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.roles TO anon;
GRANT ALL ON TABLE public.roles TO authenticated;
GRANT ALL ON TABLE public.roles TO service_role;


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 392
-- Name: SEQUENCE roles_id_rol_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.roles_id_rol_seq TO anon;
GRANT ALL ON SEQUENCE public.roles_id_rol_seq TO authenticated;
GRANT ALL ON SEQUENCE public.roles_id_rol_seq TO service_role;


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE tipo_beneficio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipo_beneficio TO anon;
GRANT ALL ON TABLE public.tipo_beneficio TO authenticated;
GRANT ALL ON TABLE public.tipo_beneficio TO service_role;


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 401
-- Name: SEQUENCE tipo_beneficio_id_tipo_beneficio_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.tipo_beneficio_id_tipo_beneficio_seq TO anon;
GRANT ALL ON SEQUENCE public.tipo_beneficio_id_tipo_beneficio_seq TO authenticated;
GRANT ALL ON SEQUENCE public.tipo_beneficio_id_tipo_beneficio_seq TO service_role;


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 464
-- Name: TABLE uso_beneficios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.uso_beneficios TO anon;
GRANT ALL ON TABLE public.uso_beneficios TO authenticated;
GRANT ALL ON TABLE public.uso_beneficios TO service_role;


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 463
-- Name: SEQUENCE uso_beneficios_id_uso_beneficio_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.uso_beneficios_id_uso_beneficio_seq TO anon;
GRANT ALL ON SEQUENCE public.uso_beneficios_id_uso_beneficio_seq TO authenticated;
GRANT ALL ON SEQUENCE public.uso_beneficios_id_uso_beneficio_seq TO service_role;


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE usuarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuarios TO anon;
GRANT ALL ON TABLE public.usuarios TO authenticated;
GRANT ALL ON TABLE public.usuarios TO service_role;


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 397
-- Name: SEQUENCE usuarios_id_usuario_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO anon;
GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO authenticated;
GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO service_role;


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 407
-- Name: TABLE v_categoria; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_categoria TO anon;
GRANT ALL ON TABLE public.v_categoria TO authenticated;
GRANT ALL ON TABLE public.v_categoria TO service_role;


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 450
-- Name: TABLE v_cliente_beneficio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_cliente_beneficio TO anon;
GRANT ALL ON TABLE public.v_cliente_beneficio TO authenticated;
GRANT ALL ON TABLE public.v_cliente_beneficio TO service_role;


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 437
-- Name: TABLE v_clientes_activos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_clientes_activos TO anon;
GRANT ALL ON TABLE public.v_clientes_activos TO authenticated;
GRANT ALL ON TABLE public.v_clientes_activos TO service_role;


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 434
-- Name: TABLE v_ingredientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_ingredientes TO anon;
GRANT ALL ON TABLE public.v_ingredientes TO authenticated;
GRANT ALL ON TABLE public.v_ingredientes TO service_role;


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 470
-- Name: TABLE v_inventario; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_inventario TO anon;
GRANT ALL ON TABLE public.v_inventario TO authenticated;
GRANT ALL ON TABLE public.v_inventario TO service_role;


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 473
-- Name: TABLE v_inventario_movimientos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_inventario_movimientos TO anon;
GRANT ALL ON TABLE public.v_inventario_movimientos TO authenticated;
GRANT ALL ON TABLE public.v_inventario_movimientos TO service_role;


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 436
-- Name: TABLE v_menu_productos_activos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_menu_productos_activos TO anon;
GRANT ALL ON TABLE public.v_menu_productos_activos TO authenticated;
GRANT ALL ON TABLE public.v_menu_productos_activos TO service_role;


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 465
-- Name: TABLE v_orden_completa; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_orden_completa TO anon;
GRANT ALL ON TABLE public.v_orden_completa TO authenticated;
GRANT ALL ON TABLE public.v_orden_completa TO service_role;


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 409
-- Name: TABLE zonas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.zonas TO anon;
GRANT ALL ON TABLE public.zonas TO authenticated;
GRANT ALL ON TABLE public.zonas TO service_role;


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 453
-- Name: TABLE v_orden_detalles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_orden_detalles TO anon;
GRANT ALL ON TABLE public.v_orden_detalles TO authenticated;
GRANT ALL ON TABLE public.v_orden_detalles TO service_role;


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 454
-- Name: TABLE v_orden_detalles_cocina; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_orden_detalles_cocina TO anon;
GRANT ALL ON TABLE public.v_orden_detalles_cocina TO authenticated;
GRANT ALL ON TABLE public.v_orden_detalles_cocina TO service_role;


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 457
-- Name: TABLE v_orden_modificadores; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_orden_modificadores TO anon;
GRANT ALL ON TABLE public.v_orden_modificadores TO authenticated;
GRANT ALL ON TABLE public.v_orden_modificadores TO service_role;


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 462
-- Name: TABLE v_orden_pagos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_orden_pagos TO anon;
GRANT ALL ON TABLE public.v_orden_pagos TO authenticated;
GRANT ALL ON TABLE public.v_orden_pagos TO service_role;


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 467
-- Name: TABLE v_orden_paquete_selecciones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_orden_paquete_selecciones TO anon;
GRANT ALL ON TABLE public.v_orden_paquete_selecciones TO authenticated;
GRANT ALL ON TABLE public.v_orden_paquete_selecciones TO service_role;


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 439
-- Name: TABLE v_ordenes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_ordenes TO anon;
GRANT ALL ON TABLE public.v_ordenes TO authenticated;
GRANT ALL ON TABLE public.v_ordenes TO service_role;


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 440
-- Name: TABLE v_ordenes_cocina; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_ordenes_cocina TO anon;
GRANT ALL ON TABLE public.v_ordenes_cocina TO authenticated;
GRANT ALL ON TABLE public.v_ordenes_cocina TO service_role;


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 441
-- Name: TABLE v_ordenes_pendientes_pago; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_ordenes_pendientes_pago TO anon;
GRANT ALL ON TABLE public.v_ordenes_pendientes_pago TO authenticated;
GRANT ALL ON TABLE public.v_ordenes_pendientes_pago TO service_role;


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 428
-- Name: TABLE v_paquete_detalle; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_paquete_detalle TO anon;
GRANT ALL ON TABLE public.v_paquete_detalle TO authenticated;
GRANT ALL ON TABLE public.v_paquete_detalle TO service_role;


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 476
-- Name: TABLE v_paquetes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_paquetes TO anon;
GRANT ALL ON TABLE public.v_paquetes TO authenticated;
GRANT ALL ON TABLE public.v_paquetes TO service_role;


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 432
-- Name: TABLE v_permisos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_permisos TO anon;
GRANT ALL ON TABLE public.v_permisos TO authenticated;
GRANT ALL ON TABLE public.v_permisos TO service_role;


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 419
-- Name: TABLE v_producto_ingrediente; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_producto_ingrediente TO anon;
GRANT ALL ON TABLE public.v_producto_ingrediente TO authenticated;
GRANT ALL ON TABLE public.v_producto_ingrediente TO service_role;


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 477
-- Name: TABLE v_productos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_productos TO anon;
GRANT ALL ON TABLE public.v_productos TO authenticated;
GRANT ALL ON TABLE public.v_productos TO service_role;


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 449
-- Name: TABLE v_promocion_clientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_promocion_clientes TO anon;
GRANT ALL ON TABLE public.v_promocion_clientes TO authenticated;
GRANT ALL ON TABLE public.v_promocion_clientes TO service_role;


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 447
-- Name: TABLE v_promocion_paquetes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_promocion_paquetes TO anon;
GRANT ALL ON TABLE public.v_promocion_paquetes TO authenticated;
GRANT ALL ON TABLE public.v_promocion_paquetes TO service_role;


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 445
-- Name: TABLE v_promocion_productos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_promocion_productos TO anon;
GRANT ALL ON TABLE public.v_promocion_productos TO authenticated;
GRANT ALL ON TABLE public.v_promocion_productos TO service_role;


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 475
-- Name: TABLE v_promociones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_promociones TO anon;
GRANT ALL ON TABLE public.v_promociones TO authenticated;
GRANT ALL ON TABLE public.v_promociones TO service_role;


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 431
-- Name: TABLE v_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_roles TO anon;
GRANT ALL ON TABLE public.v_roles TO authenticated;
GRANT ALL ON TABLE public.v_roles TO service_role;


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 433
-- Name: TABLE v_roles_permisos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_roles_permisos TO anon;
GRANT ALL ON TABLE public.v_roles_permisos TO authenticated;
GRANT ALL ON TABLE public.v_roles_permisos TO service_role;


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 474
-- Name: TABLE v_tipo_beneficio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_tipo_beneficio TO anon;
GRANT ALL ON TABLE public.v_tipo_beneficio TO authenticated;
GRANT ALL ON TABLE public.v_tipo_beneficio TO service_role;


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 466
-- Name: TABLE v_uso_beneficios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_uso_beneficios TO anon;
GRANT ALL ON TABLE public.v_uso_beneficios TO authenticated;
GRANT ALL ON TABLE public.v_uso_beneficios TO service_role;


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 438
-- Name: TABLE v_usuarios_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_usuarios_roles TO anon;
GRANT ALL ON TABLE public.v_usuarios_roles TO authenticated;
GRANT ALL ON TABLE public.v_usuarios_roles TO service_role;


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 410
-- Name: TABLE v_zonas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_zonas TO anon;
GRANT ALL ON TABLE public.v_zonas TO authenticated;
GRANT ALL ON TABLE public.v_zonas TO service_role;


--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 435
-- Name: TABLE vw_menus_activos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.vw_menus_activos TO anon;
GRANT ALL ON TABLE public.vw_menus_activos TO authenticated;
GRANT ALL ON TABLE public.vw_menus_activos TO service_role;


--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 408
-- Name: SEQUENCE zonas_id_zona_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.zonas_id_zona_seq TO anon;
GRANT ALL ON SEQUENCE public.zonas_id_zona_seq TO authenticated;
GRANT ALL ON SEQUENCE public.zonas_id_zona_seq TO service_role;


--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 383
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 377
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 380
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 379
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 385
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 389
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 390
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 386
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 387
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 388
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 391
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- TOC entry 2861 (class 826 OID 16557)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2862 (class 826 OID 16558)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2860 (class 826 OID 16556)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2871 (class 826 OID 16636)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2870 (class 826 OID 16635)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- TOC entry 2869 (class 826 OID 16634)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2874 (class 826 OID 16591)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2873 (class 826 OID 16590)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2872 (class 826 OID 16589)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2866 (class 826 OID 16571)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2868 (class 826 OID 16570)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2867 (class 826 OID 16569)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2853 (class 826 OID 16494)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2854 (class 826 OID 16495)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2852 (class 826 OID 16493)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2856 (class 826 OID 16497)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2851 (class 826 OID 16492)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2855 (class 826 OID 16496)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2864 (class 826 OID 16561)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2865 (class 826 OID 16562)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2863 (class 826 OID 16560)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2859 (class 826 OID 16550)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2858 (class 826 OID 16549)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2857 (class 826 OID 16548)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 4088 (class 3466 OID 16575)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- TOC entry 4093 (class 3466 OID 16654)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- TOC entry 4087 (class 3466 OID 16573)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- TOC entry 4094 (class 3466 OID 16657)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- TOC entry 4089 (class 3466 OID 16576)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- TOC entry 4090 (class 3466 OID 16577)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

-- Completed on 2026-05-19 19:25:54

--
-- PostgreSQL database dump complete
--

\unrestrict 6Llqi5GUyFl40X06lVkfX9NXk7gJecn8ttbmTT1turq9JI6hE6peDvor1skTFcO

