CREATE FUNCTION role_meta.set_to_role(role_name regrole, _key text, _value text) RETURNS void
    LANGUAGE plpgsql VOLATILE
    AS $_$
  BEGIN
    -- Using %s and not %I because role_name is already a valid identifier
    EXECUTE format('ALTER ROLE %s SET rolemeta.%s TO %L', role_name, _key, _value);
  END;
$_$;

COMMENT ON FUNCTION role_meta.set_to_role(role_name regrole, _key text, _value text)
    IS 'Set value of attribute in role metadata';
