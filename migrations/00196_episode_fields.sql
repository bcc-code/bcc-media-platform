-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-16T09:22:12.347Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 10, "translations" = '[{"language":"en-US","translation":"Preview Image"}]' WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 782;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 149;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 612;

UPDATE "public"."directus_fields" SET "sort" = 1, "required" = true WHERE "id" = 1172;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 146;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 140;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "hidden" = true, "sort" = 13 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 128;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 2, "required" = true WHERE "id" = 1173;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "interface" = 'custom-datepicker' WHERE "id" = 782;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE id = 149;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-16T09:22:14.337Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 140;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 146;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 149;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 8, "translations" = NULL WHERE "id" = 130;

UPDATE "public"."directus_fields" SET "hidden" = false, "sort" = 15 WHERE "id" = 143;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 128;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 119;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 565;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 612;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 124;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 148;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 125;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 147;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 782;

UPDATE "public"."directus_fields" SET "sort" = 9, "required" = false WHERE "id" = 1172;

UPDATE "public"."directus_fields" SET "sort" = 10, "required" = false WHERE "id" = 1173;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (149, 'applications_usergroups', 'applications_id', 'applications', NULL, NULL, NULL, 'usergroups_code', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
