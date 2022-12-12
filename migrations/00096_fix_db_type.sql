-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-12T14:03:30.144Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections_translations" ---

ALTER TABLE IF EXISTS "public"."sections_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE text USING "description"::text;

--- END ALTER TABLE "public"."sections_translations" ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-12T14:03:31.576Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections_translations" ---

ALTER TABLE IF EXISTS "public"."sections_translations"
	 --WARN: Change column data type can occure in a casting error, the suggested casting expression is the default one and may not fit your needs!,
	ALTER COLUMN "description" SET DATA TYPE varchar(255) USING "description"::varchar(255);

--- END ALTER TABLE "public"."sections_translations" ---
