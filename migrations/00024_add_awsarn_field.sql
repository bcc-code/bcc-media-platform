-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-10-12T14:24:05.050Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."assets" ---

ALTER TABLE IF EXISTS "public"."assets" ADD COLUMN IF NOT EXISTS "aws_arn" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."assets"."aws_arn"  IS NULL;

--- END ALTER TABLE "public"."assets" ---

--- BEGIN ALTER TABLE "public"."shows_tags" ---

ALTER TABLE IF EXISTS "public"."shows_tags" OWNER TO builder;

--- END ALTER TABLE "public"."shows_tags" ---

--- BEGIN ALTER TABLE "public"."sections_links" ---

ALTER TABLE IF EXISTS "public"."sections_links" OWNER TO builder;

--- END ALTER TABLE "public"."sections_links" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" OWNER TO builder;

--- END ALTER TABLE "public"."images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (614, 'assets', 'aws_arn', NULL, 'input', NULL, NULL, NULL, true, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2022-10-12T14:24:06.245Z            ***/
/**********************************************************/

--- BEGIN ALTER TABLE "public"."assets" ---

ALTER TABLE IF EXISTS "public"."assets" DROP COLUMN IF EXISTS "aws_arn" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."assets" ---

--- BEGIN ALTER TABLE "public"."shows_tags" ---

ALTER TABLE IF EXISTS "public"."shows_tags" OWNER TO btv;

--- END ALTER TABLE "public"."shows_tags" ---

--- BEGIN ALTER TABLE "public"."sections_links" ---

ALTER TABLE IF EXISTS "public"."sections_links" OWNER TO btv;

--- END ALTER TABLE "public"."sections_links" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" OWNER TO btv;

--- END ALTER TABLE "public"."images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 614;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
