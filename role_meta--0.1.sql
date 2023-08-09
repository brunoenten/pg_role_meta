-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION role_meta" to load this file. \quit
--
--
CREATE FUNCTION role_meta.get_from_role(role_name regrole, _key text) RETURNS text
    LANGUAGE sql STABLE
    AS $_$

  WITH role_metadata AS (
    --- From https://github.com/PostgREST/postgrest/blob/main/src/PostgREST/Config/Database.hs
    with
      role_setting as (
        select setdatabase, unnest(setconfig) as setting from pg_catalog.pg_db_role_setting
        where setrole = role_name::oid
          and setdatabase in (0, (select oid from pg_catalog.pg_database where datname = current_catalog))
      ),
      kv_settings as (
        select setdatabase, split_part(setting, '=', 1) as k, split_part(setting, '=', 2) as value from role_setting
        where setting like 'rolemeta.%'
      )
      select distinct on (key) replace(k, 'rolemeta.', '') as key, value
      from kv_settings
      order by key, setdatabase desc
  )

  SELECT "value" FROM role_metadata WHERE "key"=$2;
$_$;

COMMENT ON FUNCTION role_meta.get_from_role(role_name regrole, _key text) IS 'Get value of attribute from role metadata';
-- depends_on: ["get_from_role"]
CREATE FUNCTION role_meta.get_from_current_user(_key text) RETURNS text
    LANGUAGE sql STABLE
    AS $_$
        SELECT role_meta.get_from_role(current_user::regrole, _key);
    $_$;

COMMENT ON FUNCTION role_meta.get_from_current_user(_key text)
    IS 'Get attribute value from current user metadata';
CREATE FUNCTION role_meta.set_to_role(role_name regrole, _key text, _value text) RETURNS void
    LANGUAGE plpgsql VOLATILE
    AS $_$
  BEGIN
    EXECUTE format('ALTER ROLE %I SET rolemeta.%s TO %L', role_name, _key, _value);
  END;
$_$;

COMMENT ON FUNCTION role_meta.set_to_role(role_name regrole, _key text, _value text)
    IS 'Set value of attribute in role metadata';
-- depends_on: ["set_to_role"]
CREATE FUNCTION role_meta.set_to_current_user(_key text, _value text) RETURNS void
    LANGUAGE sql VOLATILE SECURITY DEFINER
    AS $_$
    SELECT role_meta.set_to_role(
        (CASE current_setting('role') WHEN 'none' THEN session_user ELSE current_setting('role') END)::regrole,
        _key,
        _value);
$_$;

COMMENT ON FUNCTION role_meta.set_to_current_user(_key text, _value text)
    IS 'Set value of attribute in current user metadata. Warning: security definer';
--
