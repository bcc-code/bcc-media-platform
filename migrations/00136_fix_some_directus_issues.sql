-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-15T11:05:25.167Z             ***/
/***********************************************************/

--- BEGIN ALTER SEQUENCE "public"."images_id_seq" ---
GRANT SELECT ON SEQUENCE "public"."images_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."images_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."images_id_seq" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."images_id_seq" ---

--- BEGIN ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

REVOKE SELECT ON TABLE "public"."filter_dataset" FROM api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"template":"{{label}}"}' WHERE "id" = 763;

DELETE FROM "public"."directus_fields" WHERE "id" = 983;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-15T11:05:26.821Z             ***/
/***********************************************************/

--- BEGIN ALTER SEQUENCE "public"."images_id_seq" ---

REVOKE SELECT ON SEQUENCE "public"."images_id_seq" FROM builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE USAGE ON SEQUENCE "public"."images_id_seq" FROM builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
REVOKE UPDATE ON SEQUENCE "public"."images_id_seq" FROM builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
--- END ALTER SEQUENCE "public"."images_id_seq" ---

--- BEGIN ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

GRANT SELECT ON TABLE "public"."filter_dataset" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER MATERIALIZED VIEW "public"."filter_dataset" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 763;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (983, 'targets', 'notifications', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
