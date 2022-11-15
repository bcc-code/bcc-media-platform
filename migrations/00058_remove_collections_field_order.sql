-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-15T10:07:12.390Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections" DROP COLUMN IF EXISTS "collection" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."collections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 1, "width" = 'half' WHERE "id" = 705;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 386;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 85;

DELETE FROM "public"."directus_fields" WHERE "id" = 384;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-15T10:07:13.674Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections" ---

ALTER TABLE IF EXISTS "public"."collections" ADD COLUMN IF NOT EXISTS "collection" varchar(255) NULL DEFAULT 'pages'::character varying ;

COMMENT ON COLUMN "public"."collections"."collection"  IS NULL;

--- END ALTER TABLE "public"."collections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 97;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 85;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (384, 'collections', 'collection', NULL, 'select-dropdown', '{"choices":[{"text":"Pages","value":"pages"},{"text":"Shows","value":"shows"},{"text":"Seasons","value":"seasons"},{"text":"Episodes","value":"episodes"}],"icon":"list_alt","placeholder":"Shows... seasons"}', NULL, NULL, false, false, 2, 'half', '[{"language":"en-US","translation":"Collection"}]', NULL, '[{"name":"Hidden if not Query","rule":{"_and":[{"filter_type":{"_neq":"query"}}]},"hidden":true,"options":{"allowOther":false,"allowNone":false}}]', false, 'config', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 386;

UPDATE "public"."directus_fields" SET "sort" = 4, "width" = 'full' WHERE "id" = 705;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
