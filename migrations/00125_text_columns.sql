-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-31T21:31:25.556Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

ALTER TABLE IF EXISTS "public"."tasks_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text;

ALTER TABLE IF EXISTS "public"."tasks_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "secondary_title" SET DATA TYPE text USING "secondary_title"::text;

ALTER TABLE IF EXISTS "public"."tasks_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

ALTER TABLE IF EXISTS "public"."lessons_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text;

ALTER TABLE IF EXISTS "public"."lessons_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN ALTER TABLE "public"."questionalternatives_translations" ---

ALTER TABLE IF EXISTS "public"."questionalternatives_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE text USING "title"::text;

--- END ALTER TABLE "public"."questionalternatives_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"softLength":2048}' WHERE "id" = 892;

UPDATE "public"."directus_fields" SET "options" = '{"softLength":2048}' WHERE "id" = 893;

UPDATE "public"."directus_fields" SET "options" = '{"softLength":2048}' WHERE "id" = 865;

UPDATE "public"."directus_fields" SET "options" = '{"softLength":1024}' WHERE "id" = 995;

UPDATE "public"."directus_fields" SET "options" = '{"softLength":1024}' WHERE "id" = 839;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-31T21:31:27.106Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."tasks_translations" ---

ALTER TABLE IF EXISTS "public"."tasks_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255);

ALTER TABLE IF EXISTS "public"."tasks_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "secondary_title" SET DATA TYPE varchar(255) USING "secondary_title"::varchar(255);

ALTER TABLE IF EXISTS "public"."tasks_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

--- END ALTER TABLE "public"."tasks_translations" ---

--- BEGIN ALTER TABLE "public"."lessons_translations" ---

ALTER TABLE IF EXISTS "public"."lessons_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255);

ALTER TABLE IF EXISTS "public"."lessons_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

--- END ALTER TABLE "public"."lessons_translations" ---

--- BEGIN ALTER TABLE "public"."questionalternatives_translations" ---

ALTER TABLE IF EXISTS "public"."questionalternatives_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "title" SET DATA TYPE varchar(255) USING "title"::varchar(255);

--- END ALTER TABLE "public"."questionalternatives_translations" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 865;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 839;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 892;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 893;

UPDATE "public"."directus_fields" SET "options" = NULL WHERE "id" = 995;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
