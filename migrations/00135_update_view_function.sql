-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-14T12:56:28.031Z             ***/
/***********************************************************/

--- BEGIN ALTER FUNCTION "public"."update_view"(character varying) ---

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION public.update_view(view character varying)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$
BEGIN
    CASE
        WHEN view = 'filter_dataset' THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY filter_dataset;
        ELSE
            RAISE EXCEPTION 'Invalid view';
    END CASE;
    INSERT INTO materialized_views_meta (last_refreshed, view_name)
    VALUES (NOW(), view)
    ON CONFLICT(view_name) DO UPDATE set last_refreshed = now();
    RETURN true;
END
$$
;

-- +goose StatementEnd
GRANT EXECUTE ON FUNCTION "public"."update_view"(character varying) TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT EXECUTE ON FUNCTION "public"."update_view"(character varying) TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON FUNCTION "public"."update_view"(character varying)  IS NULL;

--- END ALTER FUNCTION "public"."update_view"(character varying) ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-14T12:56:29.575Z             ***/
/***********************************************************/

--- BEGIN ALTER FUNCTION "public"."update_view"(character varying) ---


-- +goose StatementBegin
CREATE OR REPLACE FUNCTION public.update_view(view character varying)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$
BEGIN
    CASE
        WHEN view = 'filter_dataset' THEN
            REFRESH MATERIALIZED VIEW filter_dataset;
        ELSE
            RAISE EXCEPTION 'Invalid view';
    END CASE;
    INSERT INTO materialized_views_meta (last_refreshed, view_name)
    VALUES (NOW(), view)
    ON CONFLICT(view_name) DO UPDATE set last_refreshed = now();
    RETURN true;
END
$$
;
-- +goose StatementEnd
GRANT EXECUTE ON FUNCTION "public"."update_view"(character varying) TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT EXECUTE ON FUNCTION "public"."update_view"(character varying) TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON FUNCTION "public"."update_view"(character varying)  IS NULL;

--- END ALTER FUNCTION "public"."update_view"(character varying) ---
