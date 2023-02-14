-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-14T12:42:59.337Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons"
    ADD COLUMN IF NOT EXISTS "uuid" uuid NULL;

COMMENT ON COLUMN "public"."seasons"."uuid" IS NULL;

CREATE UNIQUE INDEX seasons_uuid_uindex ON public.seasons USING btree (uuid);

COMMENT ON INDEX "public"."seasons_uuid_uindex" IS NULL;

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows"
    ADD COLUMN IF NOT EXISTS "uuid" uuid NULL;

COMMENT ON COLUMN "public"."shows"."uuid" IS NULL;

CREATE UNIQUE INDEX shows_uuid_uindex ON public.shows USING btree (uuid);

COMMENT ON INDEX "public"."shows_uuid_uindex" IS NULL;

--- END ALTER TABLE "public"."shows" ---

--- Fill fields and set not null
UPDATE "public"."shows"
SET uuid = gen_random_uuid();

UPDATE "public"."seasons"
SET uuid = gen_random_uuid();

ALTER TABLE "public"."shows"
    ALTER COLUMN uuid SET NOT NULL;

ALTER TABLE "public"."seasons"
    ALTER COLUMN uuid SET NOT NULL;
--- End fill fields set null

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-14T12:43:00.956Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."seasons" ---

ALTER TABLE IF EXISTS "public"."seasons"
    DROP COLUMN IF EXISTS "uuid" CASCADE; --WARN: Drop column can occure in data loss!

DROP INDEX IF EXISTS seasons_uuid_uindex;

--- END ALTER TABLE "public"."seasons" ---

--- BEGIN ALTER TABLE "public"."shows" ---

ALTER TABLE IF EXISTS "public"."shows"
    DROP COLUMN IF EXISTS "uuid" CASCADE; --WARN: Drop column can occure in data loss!

DROP INDEX IF EXISTS shows_uuid_uindex;

--- END ALTER TABLE "public"."shows" ---
