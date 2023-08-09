-- depends_on: ["get_from_role"]
CREATE FUNCTION role_meta.get_from_current_user(_key text) RETURNS text
    LANGUAGE sql STABLE
    AS $_$
        SELECT role_meta.get_from_role(current_user::regrole, _key);
    $_$;

COMMENT ON FUNCTION role_meta.get_from_current_user(_key text)
    IS 'Get attribute value from current user metadata';