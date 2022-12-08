-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-08T13:51:39.103Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."tasks_images" ---

CREATE TABLE IF NOT EXISTS "public"."tasks_images" (
	"id" uuid NOT NULL  ,
	"image" uuid NOT NULL  ,
	"language" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"task_id" uuid NOT NULL  ,
	CONSTRAINT "tasks_images_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "tasks_images_language_foreign" FOREIGN KEY (language) REFERENCES languages(code) ,
	CONSTRAINT "tasks_images_task_id_foreign" FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE ,
	CONSTRAINT "tasks_images_image_foreign" FOREIGN KEY (image) REFERENCES directus_files(id)
);

ALTER TABLE IF EXISTS "public"."tasks_images" OWNER TO builder;

GRANT SELECT ON TABLE "public"."tasks_images" TO api, directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."tasks_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."tasks_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."tasks_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."tasks_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."tasks_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."tasks_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."tasks_images"."id"  IS NULL;


COMMENT ON COLUMN "public"."tasks_images"."image"  IS NULL;


COMMENT ON COLUMN "public"."tasks_images"."language"  IS NULL;


COMMENT ON COLUMN "public"."tasks_images"."task_id"  IS NULL;

COMMENT ON CONSTRAINT "tasks_images_pkey" ON "public"."tasks_images" IS NULL;


COMMENT ON CONSTRAINT "tasks_images_language_foreign" ON "public"."tasks_images" IS NULL;


COMMENT ON CONSTRAINT "tasks_images_task_id_foreign" ON "public"."tasks_images" IS NULL;


COMMENT ON CONSTRAINT "tasks_images_image_foreign" ON "public"."tasks_images" IS NULL;

COMMENT ON TABLE "public"."tasks_images"  IS NULL;

--- END CREATE TABLE "public"."tasks_images" ---

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "episode_id" int4 NULL  ;

COMMENT ON COLUMN "public"."tasks"."episode_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "link" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."tasks"."link"  IS NULL;

ALTER TABLE IF EXISTS "public"."tasks" ADD COLUMN IF NOT EXISTS "image_type" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."tasks"."image_type"  IS NULL;

ALTER TABLE IF EXISTS "public"."tasks" ADD CONSTRAINT "tasks_episode_id_foreign" FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tasks_episode_id_foreign" ON "public"."tasks" IS NULL;

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tasks_images', NULL, NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (888, 'tasks_images', 'task_id', NULL, 'select-dropdown-m2o', NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (889, 'tasks', 'link', NULL, 'input', NULL, 'raw', NULL, false, true, NULL, 'full', NULL, NULL, '[{"name":"show if link","hidden":false,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (879, 'tasks', 'episode_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, NULL, 'full', NULL, NULL, '[{"name":"show if video","rule":{"_and":[{"type":{"_eq":"video"}}]},"hidden":false,"options":{"enableCreate":true,"enableSelect":true}}]', false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Question","value":"question"},{"text":"Image","value":"image"},{"text":"Video","value":"video"},{"text":"Link","value":"link"}]}' WHERE "id" = 806;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (891, 'tasks', 'image_type', NULL, 'select-dropdown', '{"choices":[{"text":"Poster","value":"poster"},{"text":"Quote","value":"quote"}]}', NULL, NULL, false, true, NULL, 'full', NULL, NULL, '[{"name":"show if image","rule":{"_and":[{"type":{"_eq":"image"}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (884, 'tasks_images', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (887, 'tasks', 'images', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, true, NULL, 'full', NULL, NULL, '[{"name":"show if image","rule":{"_and":[{"type":{"_eq":"image"}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (886, 'tasks_images', 'language', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (885, 'tasks_images', 'image', 'file', 'file-image', NULL, 'image', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"},{"text":"Unlisted","value":"unlisted"}],"icon":"visibility"}', "display_options" = '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"},{"text":"Unlisted","value":"unlisted","foreground":"#FFC23B","background":"#FFC23B"}],"showAsDot":true}' WHERE "id" = 141;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (266, 'tasks', 'episode_id', 'episodes', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (270, 'tasks_images', 'language', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (271, 'tasks_images', 'task_id', 'tasks', 'images', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (269, 'tasks_images', 'image', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" DROP CONSTRAINT IF EXISTS "tasks_lesson_id_foreign";

ALTER TABLE IF EXISTS "public"."tasks" ADD CONSTRAINT "tasks_lesson_id_foreign" FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "tasks_lesson_id_foreign" ON "public"."tasks" IS NULL;

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (828, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks_images', 'create', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (829, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks_images', 'read', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (830, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks_images', 'delete', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (831, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks_images', 'update', '{}', '{}', NULL, '*');

INSERT INTO "public"."directus_permissions" ("id", "role", "collection", "action", "permissions", "validation", "presets", "fields")  VALUES (832, '156d86ef-4c0e-4886-8bee-3a3c346fdb23', 'tasks_images', 'share', '{}', '{}', NULL, '*');

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 250;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-08T13:51:40.617Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "episode_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "link" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."tasks" DROP COLUMN IF EXISTS "image_type" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."tasks" DROP CONSTRAINT IF EXISTS "tasks_episode_id_foreign";

--- END ALTER TABLE "public"."tasks" ---

--- BEGIN DROP TABLE "public"."tasks_images" ---

DROP TABLE IF EXISTS "public"."tasks_images";

--- END DROP TABLE "public"."tasks_images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'tasks_images';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}],"icon":"visibility"}', "display_options" = '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}' WHERE "id" = 141;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Question","value":"question"},{"text":"Poster","value":"poster"}]}' WHERE "id" = 806;

DELETE FROM "public"."directus_fields" WHERE "id" = 888;

DELETE FROM "public"."directus_fields" WHERE "id" = 889;

DELETE FROM "public"."directus_fields" WHERE "id" = 879;

DELETE FROM "public"."directus_fields" WHERE "id" = 891;

DELETE FROM "public"."directus_fields" WHERE "id" = 884;

DELETE FROM "public"."directus_fields" WHERE "id" = 887;

DELETE FROM "public"."directus_fields" WHERE "id" = 886;

DELETE FROM "public"."directus_fields" WHERE "id" = 885;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 266;

DELETE FROM "public"."directus_relations" WHERE "id" = 270;

DELETE FROM "public"."directus_relations" WHERE "id" = 271;

DELETE FROM "public"."directus_relations" WHERE "id" = 269;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---


--- BEGIN ALTER TABLE "public"."tasks" ---

ALTER TABLE IF EXISTS "public"."tasks" DROP CONSTRAINT IF EXISTS "tasks_lesson_id_foreign";

ALTER TABLE IF EXISTS "public"."tasks" ADD CONSTRAINT "tasks_lesson_id_foreign" FOREIGN KEY (lesson_id) REFERENCES lessons(id);

COMMENT ON CONSTRAINT "tasks_lesson_id_foreign" ON "public"."tasks" IS NULL;

--- END ALTER TABLE "public"."tasks" ---


--- BEGIN SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

DELETE FROM "public"."directus_permissions" WHERE "id" = 828;

DELETE FROM "public"."directus_permissions" WHERE "id" = 829;

DELETE FROM "public"."directus_permissions" WHERE "id" = 830;

DELETE FROM "public"."directus_permissions" WHERE "id" = 831;

DELETE FROM "public"."directus_permissions" WHERE "id" = 832;

--- END SYNCHRONIZE TABLE "public"."directus_permissions" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 250;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
