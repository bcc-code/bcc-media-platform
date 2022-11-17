-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-08T11:08:53.311Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections_translations" ---

ALTER TABLE IF EXISTS "public"."sections_translations" DROP CONSTRAINT IF EXISTS "sections_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."sections_translations"
	ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."sections_translations" DROP CONSTRAINT IF EXISTS "sections_translations_sections_id_foreign";

DELETE FROM "public"."sections_translations" WHERE "sections_id" IS NULL;

ALTER TABLE IF EXISTS "public"."sections_translations"
	ALTER COLUMN "sections_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."sections_translations" ADD CONSTRAINT "sections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code);

COMMENT ON CONSTRAINT "sections_translations_languages_code_foreign" ON "public"."sections_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."sections_translations" ADD CONSTRAINT "sections_translations_sections_id_foreign" FOREIGN KEY (sections_id) REFERENCES sections(id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "sections_translations_sections_id_foreign" ON "public"."sections_translations" IS NULL;

--- END ALTER TABLE "public"."sections_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-08T11:08:54.596Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections_translations" ---

ALTER TABLE IF EXISTS "public"."sections_translations" DROP CONSTRAINT IF EXISTS "sections_translations_languages_code_foreign";

ALTER TABLE IF EXISTS "public"."sections_translations"
	ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."sections_translations" DROP CONSTRAINT IF EXISTS "sections_translations_sections_id_foreign";

ALTER TABLE IF EXISTS "public"."sections_translations"
	ALTER COLUMN "sections_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."sections_translations" ADD CONSTRAINT "sections_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages(code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "sections_translations_languages_code_foreign" ON "public"."sections_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."sections_translations" ADD CONSTRAINT "sections_translations_sections_id_foreign" FOREIGN KEY (sections_id) REFERENCES sections(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "sections_translations_sections_id_foreign" ON "public"."sections_translations" IS NULL;

--- END ALTER TABLE "public"."sections_translations" ---
