-- Deploy util_fn:trim_text to pg
-- requires: schema

BEGIN;

  drop function if exists util_fn.trim_text(text);

COMMIT;
