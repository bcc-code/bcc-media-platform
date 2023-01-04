-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-03T10:26:10.239Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."lessons_images" ---

CREATE TABLE IF NOT EXISTS "public"."lessons_images" (
	"id" uuid NOT NULL  ,
	"lesson_id" uuid NULL  ,
	"file" uuid NOT NULL  ,
	"language" varchar(255) NOT NULL  ,
	"style" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "lessons_images_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "lessons_images_file_foreign" FOREIGN KEY (file) REFERENCES directus_files(id) ,
	CONSTRAINT "lessons_images_language_foreign" FOREIGN KEY (language) REFERENCES languages(code) ,
	CONSTRAINT "lessons_images_lesson_id_foreign" FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."lessons_images" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."lessons_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."lessons_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."lessons_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."lessons_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."lessons_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."lessons_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."lessons_images"."id"  IS NULL;


COMMENT ON COLUMN "public"."lessons_images"."lesson_id"  IS NULL;


COMMENT ON COLUMN "public"."lessons_images"."file"  IS NULL;


COMMENT ON COLUMN "public"."lessons_images"."language"  IS NULL;


COMMENT ON COLUMN "public"."lessons_images"."style"  IS NULL;

COMMENT ON CONSTRAINT "lessons_images_pkey" ON "public"."lessons_images" IS NULL;


COMMENT ON CONSTRAINT "lessons_images_file_foreign" ON "public"."lessons_images" IS NULL;


COMMENT ON CONSTRAINT "lessons_images_language_foreign" ON "public"."lessons_images" IS NULL;


COMMENT ON CONSTRAINT "lessons_images_lesson_id_foreign" ON "public"."lessons_images" IS NULL;

COMMENT ON TABLE "public"."lessons_images"  IS NULL;

--- END CREATE TABLE "public"."lessons_images" ---

--- BEGIN ALTER TABLE "public"."studytopics" ---

ALTER TABLE IF EXISTS "public"."studytopics" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."studytopics"."description"  IS NULL;

--- END ALTER TABLE "public"."studytopics" ---

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."lessons"."description"  IS NULL;

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

ALTER TABLE IF EXISTS "public"."studytopics_translations" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."studytopics_translations"."description"  IS NULL;

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

ALTER TABLE IF EXISTS "public"."lessons_translations" ADD COLUMN IF NOT EXISTS "description" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."lessons_translations"."description"  IS NULL;

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN CREATE TABLE "public"."studytopics_images" ---

CREATE TABLE IF NOT EXISTS "public"."studytopics_images" (
	"id" uuid NOT NULL  ,
	"topic_id" uuid NOT NULL  ,
	"file" uuid NOT NULL  ,
	"language" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	"style" varchar(255) NULL  ,
	CONSTRAINT "studytopics_images_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "studytopics_images_file_foreign" FOREIGN KEY (file) REFERENCES directus_files(id) ,
	CONSTRAINT "studytopics_images_language_foreign" FOREIGN KEY (language) REFERENCES languages(code) ,
	CONSTRAINT "studytopics_images_topic_id_foreign" FOREIGN KEY (topic_id) REFERENCES studytopics(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."studytopics_images" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."studytopics_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."studytopics_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."studytopics_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."studytopics_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."studytopics_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."studytopics_images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."studytopics_images"."id"  IS NULL;


COMMENT ON COLUMN "public"."studytopics_images"."topic_id"  IS NULL;


COMMENT ON COLUMN "public"."studytopics_images"."file"  IS NULL;


COMMENT ON COLUMN "public"."studytopics_images"."language"  IS NULL;


COMMENT ON COLUMN "public"."studytopics_images"."style"  IS NULL;

COMMENT ON CONSTRAINT "studytopics_images_pkey" ON "public"."studytopics_images" IS NULL;


COMMENT ON CONSTRAINT "studytopics_images_file_foreign" ON "public"."studytopics_images" IS NULL;


COMMENT ON CONSTRAINT "studytopics_images_language_foreign" ON "public"."studytopics_images" IS NULL;


COMMENT ON CONSTRAINT "studytopics_images_topic_id_foreign" ON "public"."studytopics_images" IS NULL;

COMMENT ON TABLE "public"."studytopics_images"  IS NULL;

--- END CREATE TABLE "public"."studytopics_images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'achievements';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'tasks';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'studies';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'notifications';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('studytopics_images', NULL, NULL, '{{file}}{{language}}{{style}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'studytopics', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('lessons_images', NULL, NULL, '{{file}}{{language}}{{style}}', true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, 1, 'lessons', 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 850;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (995, 'lessons', 'description', NULL, NULL, NULL, NULL, NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (996, 'lessons_translations', 'description', NULL, NULL, NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (987, 'studytopics_images', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (994, 'studytopics_translations', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1001, 'lessons_images', 'language', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (997, 'lessons_images', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (989, 'studytopics_images', 'file', 'file', 'file-image', NULL, 'image', NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (988, 'studytopics_images', 'topic_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 859;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 831;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (991, 'studytopics_images', 'style', NULL, 'select-dropdown', '{"choices":[{"text":"Default","value":"default"},{"text":"Poster","value":"poster"},{"text":"Featured","value":"featured"},{"text":"Icon","value":"icon"}]}', NULL, NULL, false, false, 4, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (990, 'studytopics_images', 'language', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (998, 'lessons_images', 'lesson_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (999, 'lessons', 'images', 'o2m', 'list-o2m', '{"enableSelect":false}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 847;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (992, 'studytopics', 'images', 'o2m', 'list-o2m', '{"enableSelect":false}', 'related-values', NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1000, 'lessons_images', 'file', 'file', 'file-image', NULL, 'image', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (993, 'studytopics', 'description', NULL, 'input', NULL, 'raw', NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1002, 'lessons_images', 'style', NULL, 'select-dropdown', '{"choices":[{"text":"Default","value":"default"},{"text":"Featured","value":"featured"},{"text":"Poster","value":"poster"},{"text":"Icon","value":"icon"}]}', NULL, NULL, false, false, 5, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_allowed_collections" = 'episodes,links,pages,seasons,shows,studytopics' WHERE "id" = 214;

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (308, 'lessons_images', 'file', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (309, 'lessons_images', 'language', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (307, 'lessons_images', 'lesson_id', 'lessons', 'images', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (305, 'studytopics_images', 'file', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (306, 'studytopics_images', 'language', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (304, 'studytopics_images', 'topic_id', 'studytopics', 'images', NULL, NULL, NULL, NULL, 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-03T10:26:11.679Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."lessons" ---

ALTER TABLE IF EXISTS "public"."lessons" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."lessons" ---

--- BEGIN ALTER TABLE "public"."studytopics" ---

ALTER TABLE IF EXISTS "public"."studytopics" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."studytopics" ---

--- BEGIN ALTER TABLE "public"."studytopics_translations" ---

ALTER TABLE IF EXISTS "public"."studytopics_translations" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."studytopics_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

ALTER TABLE IF EXISTS "public"."lessons_translations" DROP COLUMN IF EXISTS "description" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN DROP TABLE "public"."lessons_images" ---

DROP TABLE IF EXISTS "public"."lessons_images";

--- END DROP TABLE "public"."lessons_images" ---

--- BEGIN DROP TABLE "public"."studytopics_images" ---

DROP TABLE IF EXISTS "public"."studytopics_images";

--- END DROP TABLE "public"."studytopics_images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'tasks';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'achievements';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'studies';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'notifications';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'studytopics_images';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'lessons_images';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 866;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 859;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 850;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 831;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 847;

DELETE FROM "public"."directus_fields" WHERE "id" = 995;

DELETE FROM "public"."directus_fields" WHERE "id" = 996;

DELETE FROM "public"."directus_fields" WHERE "id" = 987;

DELETE FROM "public"."directus_fields" WHERE "id" = 994;

DELETE FROM "public"."directus_fields" WHERE "id" = 1001;

DELETE FROM "public"."directus_fields" WHERE "id" = 997;

DELETE FROM "public"."directus_fields" WHERE "id" = 989;

DELETE FROM "public"."directus_fields" WHERE "id" = 988;

DELETE FROM "public"."directus_fields" WHERE "id" = 991;

DELETE FROM "public"."directus_fields" WHERE "id" = 990;

DELETE FROM "public"."directus_fields" WHERE "id" = 998;

DELETE FROM "public"."directus_fields" WHERE "id" = 999;

DELETE FROM "public"."directus_fields" WHERE "id" = 992;

DELETE FROM "public"."directus_fields" WHERE "id" = 1000;

DELETE FROM "public"."directus_fields" WHERE "id" = 993;

DELETE FROM "public"."directus_fields" WHERE "id" = 1002;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_allowed_collections" = 'episodes,links,pages,seasons,shows' WHERE "id" = 214;

DELETE FROM "public"."directus_relations" WHERE "id" = 308;

DELETE FROM "public"."directus_relations" WHERE "id" = 309;

DELETE FROM "public"."directus_relations" WHERE "id" = 307;

DELETE FROM "public"."directus_relations" WHERE "id" = 305;

DELETE FROM "public"."directus_relations" WHERE "id" = 306;

DELETE FROM "public"."directus_relations" WHERE "id" = 304;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
