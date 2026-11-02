-- +goose Up

--- BEGIN ALTER TABLE "public"."episodes" ADD "override_url_from" ---

ALTER TABLE "public"."episodes" ADD COLUMN IF NOT EXISTS "override_url_from" timestamp NULL;

COMMENT ON COLUMN "public"."episodes"."override_url" IS 'URL clients open instead of playing the episode, between override_url_from and override_url_until. Set automatically for meeting episodes (Live app replay); NULL for all other episodes.';

COMMENT ON COLUMN "public"."episodes"."override_url_from" IS 'When override_url starts applying. NULL = immediately.';

--- END ALTER TABLE "public"."episodes" ADD "override_url_from" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3110, 'episodes', 'override_url_from', NULL, 'datetime', NULL, 'datetime', NULL, true, false, 21, 'half', NULL, 'Set automatically: the meeting end. Before this time the episode plays normally.', NULL, false, 'configuration', NULL, NULL);

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 3108;

UPDATE "public"."directus_fields" SET "sort" = 22 WHERE "id" = 3109;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 3110;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 3108;

UPDATE "public"."directus_fields" SET "sort" = 21 WHERE "id" = 3109;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN ALTER TABLE "public"."episodes" DROP "override_url_from" ---

COMMENT ON COLUMN "public"."episodes"."override_url" IS 'URL clients open instead of playing the episode, until override_url_until. Set automatically for meeting episodes (Live app replay); NULL for all other episodes.';

ALTER TABLE "public"."episodes" DROP COLUMN IF EXISTS "override_url_from";

--- END ALTER TABLE "public"."episodes" DROP "override_url_from" ---
