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
