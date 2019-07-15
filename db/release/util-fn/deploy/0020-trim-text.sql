-- Deploy util_fn:structure/trim_text to pg
-- requires: structure/schema

begin;
  create or replace function util_fn.trim_text(
    _input text
  ) returns text AS $$
  DECLARE
    _trim_regex text;
    _retval text;
  BEGIN
    -- _app_user := (SELECT auth_fn.current_app_user());
    _trim_regex := '\S(?:.*\S)*';
    _retval = substring(_input, _trim_regex);
    return _retval;
  END;
  $$ language plpgsql strict security definer;
  --||--
  GRANT execute ON FUNCTION util_fn.trim_text(text) TO app_anonymous;

commit;