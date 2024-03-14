-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-14T08:20:39.026Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems_tags" ---

ALTER TABLE IF EXISTS "public"."mediaitems_tags" DROP CONSTRAINT IF EXISTS "mediaitems_tags_mediaitems_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_tags" ADD CONSTRAINT "mediaitems_tags_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "mediaitems_tags_mediaitems_id_foreign" ON "public"."mediaitems_tags" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_tags" DROP CONSTRAINT IF EXISTS "mediaitems_tags_tags_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_tags" ADD CONSTRAINT "mediaitems_tags_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "mediaitems_tags_tags_id_foreign" ON "public"."mediaitems_tags" IS NULL;

--- END ALTER TABLE "public"."mediaitems_tags" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"enableCreate":false}', "sort" = 7 WHERE "id" = 298;

UPDATE "public"."directus_fields" SET "options" = '{"enableCreate":false}', "sort" = 8 WHERE "id" = 568;

UPDATE "public"."directus_fields" SET "options" = '{"enableCreate":false}', "sort" = 9 WHERE "id" = 573;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1485, 'tags', 'mediaitems', 'm2m', 'list-m2m', '{"template":"{{mediaitems_id}}","enableCreate":false}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 47;

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 172;

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 174;

UPDATE "public"."directus_relations" SET "one_field" = 'mediaitems', "one_deselect_action" = 'delete' WHERE "id" = 429;

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true) FROM "public"."directus_relations";

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-14T08:20:40.722Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems_tags" ---

ALTER TABLE IF EXISTS "public"."mediaitems_tags" DROP CONSTRAINT IF EXISTS "mediaitems_tags_mediaitems_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_tags" ADD CONSTRAINT "mediaitems_tags_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_tags_mediaitems_id_foreign" ON "public"."mediaitems_tags" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_tags" DROP CONSTRAINT IF EXISTS "mediaitems_tags_tags_id_foreign";

ALTER TABLE IF EXISTS "public"."mediaitems_tags" ADD CONSTRAINT "mediaitems_tags_tags_id_foreign" FOREIGN KEY (tags_id) REFERENCES tags(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_tags_tags_id_foreign" ON "public"."mediaitems_tags" IS NULL;

--- END ALTER TABLE "public"."mediaitems_tags" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = NULL, "sort" = 6 WHERE "id" = 298;

UPDATE "public"."directus_fields" SET "options" = NULL, "sort" = NULL WHERE "id" = 573;

UPDATE "public"."directus_fields" SET "options" = NULL, "sort" = NULL WHERE "id" = 568;

DELETE FROM "public"."directus_fields" WHERE "id" = 1485;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 47;

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 172;

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 174;

UPDATE "public"."directus_relations" SET "one_field" = NULL, "one_deselect_action" = 'nullify' WHERE "id" = 429;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
