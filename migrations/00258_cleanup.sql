-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-06T11:07:41.036Z             ***/
/***********************************************************/

DELETE
FROM "public"."calendarentries_translations"
WHERE languages_code = '';

--- BEGIN ALTER TABLE "public"."calendarentries_translations" ---

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
    ADD CONSTRAINT "calendarentries_translations_pk" UNIQUE (calendarentries_id, languages_code);

COMMENT ON CONSTRAINT "calendarentries_translations_pk" ON "public"."calendarentries_translations" IS NULL;

-- CREATE UNIQUE INDEX calendarentries_translations_pk ON public.calendarentries_translations USING btree (calendarentries_id, languages_code);

COMMENT ON INDEX "public"."calendarentries_translations_pk" IS NULL;

--- END ALTER TABLE "public"."calendarentries_translations" ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-06T11:07:42.584Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."calendarentries_translations" ---

ALTER TABLE IF EXISTS "public"."calendarentries_translations"
    DROP CONSTRAINT IF EXISTS "calendarentries_translations_pk";

DROP INDEX IF EXISTS calendarentries_translations_pk;

--- END ALTER TABLE "public"."calendarentries_translations" ---
