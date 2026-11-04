-- +goose Up

--- BEGIN ALTER TABLE "public"."episodes" ADD "override_url" ---

ALTER TABLE "public"."episodes" ADD COLUMN IF NOT EXISTS "override_url" text NULL;

COMMENT ON COLUMN "public"."episodes"."override_url" IS 'URL clients open instead of playing the episode. Takes precedence over the automatic Live app redirect of meeting episodes.';

--- END ALTER TABLE "public"."episodes" ADD "override_url" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3108, 'episodes', 'override_url', NULL, 'input', NULL, NULL, NULL, false, false, 20, 'half', NULL, 'Opens this URL instead of playing the episode. Overrides the automatic Live app redirect while a meeting is in the live buffer.', NULL, false, 'configuration', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 3108;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN ALTER TABLE "public"."episodes" DROP "override_url" ---

ALTER TABLE "public"."episodes" DROP COLUMN IF EXISTS "override_url";

--- END ALTER TABLE "public"."episodes" DROP "override_url" ---
