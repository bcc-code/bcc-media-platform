CREATE OR REPLACE FUNCTION immutable_concat_ws(text, VARIADIC text[])
RETURNS text AS 'text_concat_ws' LANGUAGE internal IMMUTABLE PARALLEL SAFE;