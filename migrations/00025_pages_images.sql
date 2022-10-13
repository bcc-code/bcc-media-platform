-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-13T08:50:50.582Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" ADD COLUMN IF NOT EXISTS "page_id" int4 NULL  ;

COMMENT ON COLUMN "public"."images"."page_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "images_page_id_foreign" FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "images_page_id_foreign" ON "public"."images" IS NULL;

--- END ALTER TABLE "public"."images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (626, 'pages', 'images', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"episode_id":{"_null":true}},{"page_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 558;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 561;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"season_id":{"_null":true}},{"page_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 559;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (625, 'images', 'page_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 9, 'full', NULL, NULL, '[{"name":"Shown if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"season_id":{"_null":true}},{"episode_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]', false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 396;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 560;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 562;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"season_id":{"_null":true}},{"episode_id":{"_null":true}},{"page_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 557;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (191, 'images', 'page_id', 'pages', 'images', NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-13T08:50:51.768Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" DROP COLUMN IF EXISTS "page_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "images_page_id_foreign";

--- END ALTER TABLE "public"."images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 396;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 560;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 562;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"season_id":{"_null":true}},{"episode_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 557;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"episode_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 558;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"season_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]' WHERE "id" = 559;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 561;

DELETE FROM "public"."directus_fields" WHERE "id" = 626;

DELETE FROM "public"."directus_fields" WHERE "id" = 625;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 191;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
