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
