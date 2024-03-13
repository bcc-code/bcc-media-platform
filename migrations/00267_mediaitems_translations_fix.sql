-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-13T09:46:28.988Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems_translations" ---

DELETE
FROM "public"."mediaitems_translations"
WHERE mediaitems_id IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    DROP CONSTRAINT IF EXISTS "mediaitems_translations_mediaitems_id_foreign";

DROP INDEX IF EXISTS mediaitems_translations_pk;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    ALTER COLUMN "mediaitems_id" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    DROP CONSTRAINT IF EXISTS "mediaitems_translations_languages_code_foreign";

DROP INDEX IF EXISTS mediaitems_translations_pk;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    ALTER COLUMN "languages_code" SET NOT NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    ADD CONSTRAINT "mediaitems_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "mediaitems_translations_languages_code_foreign" ON "public"."mediaitems_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    ADD CONSTRAINT "mediaitems_translations_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE CASCADE;

COMMENT ON CONSTRAINT "mediaitems_translations_mediaitems_id_foreign" ON "public"."mediaitems_translations" IS NULL;

CREATE UNIQUE INDEX mediaitems_translations_pk ON public.mediaitems_translations USING btree (mediaitems_id, languages_code);

COMMENT ON INDEX "public"."mediaitems_translations_pk" IS NULL;

INSERT INTO mediaitems_tags (mediaitems_id, tags_id)
SELECT DISTINCT e.uuid, t.tags_id
FROM episodes_tags t
         JOIN episodes e ON e.id = t.episodes_id;

--- END ALTER TABLE "public"."mediaitems_translations" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-13T09:46:30.742Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."mediaitems_translations" ---

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    DROP CONSTRAINT IF EXISTS "mediaitems_translations_mediaitems_id_foreign";

DROP INDEX IF EXISTS mediaitems_translations_pk;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    ALTER COLUMN "mediaitems_id" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    DROP CONSTRAINT IF EXISTS "mediaitems_translations_languages_code_foreign";

DROP INDEX IF EXISTS mediaitems_translations_pk;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    ALTER COLUMN "languages_code" DROP NOT NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    ADD CONSTRAINT "mediaitems_translations_languages_code_foreign" FOREIGN KEY (languages_code) REFERENCES languages (code) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_translations_languages_code_foreign" ON "public"."mediaitems_translations" IS NULL;

ALTER TABLE IF EXISTS "public"."mediaitems_translations"
    ADD CONSTRAINT "mediaitems_translations_mediaitems_id_foreign" FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "mediaitems_translations_mediaitems_id_foreign" ON "public"."mediaitems_translations" IS NULL;

CREATE UNIQUE INDEX mediaitems_translations_pk ON public.mediaitems_translations USING btree (mediaitems_id, languages_code);

COMMENT ON INDEX "public"."mediaitems_translations_pk" IS NULL;

--- END ALTER TABLE "public"."mediaitems_translations" ---
