CREATE FUNCTION role_meta.set_to_role(role_name regrole, _key text, _value text) RETURNS void
    LANGUAGE plpgsql VOLATILE
    AS $_$
  BEGIN
    EXECUTE format('ALTER ROLE %I SET rolemeta.%s TO %L', role_name, _key, _value);
  END;
$_$;

COMMENT ON FUNCTION role_meta.set_to_role(role_name regrole, _key text, _value text)
    IS 'Set value of attribute in role metadata';
