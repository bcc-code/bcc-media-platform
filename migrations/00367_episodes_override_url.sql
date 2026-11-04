-- +goose Up

--- BEGIN ALTER TABLE "public"."episodes" ADD "override_url" ---

ALTER TABLE "public"."episodes" ADD COLUMN IF NOT EXISTS "override_url" text NULL;

COMMENT ON COLUMN "public"."episodes"."override_url" IS 'URL clients open instead of playing the episode. Takes precedence over the automatic Live app redirect of meeting episodes.';

--- END ALTER TABLE "public"."episodes" ADD "override_url" ---

-- +goose Down

--- BEGIN ALTER TABLE "public"."episodes" DROP "override_url" ---

ALTER TABLE "public"."episodes" DROP COLUMN IF EXISTS "override_url";

--- END ALTER TABLE "public"."episodes" DROP "override_url" ---
