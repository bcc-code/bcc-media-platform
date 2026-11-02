-- +goose Up

--- BEGIN ALTER TABLE "public"."episodes" ADD "override_url" / "override_url_until" ---

ALTER TABLE "public"."episodes" ADD COLUMN IF NOT EXISTS "override_url" text NULL;

ALTER TABLE "public"."episodes" ADD COLUMN IF NOT EXISTS "override_url_until" timestamp NULL;

COMMENT ON COLUMN "public"."episodes"."override_url" IS 'URL clients open instead of playing the episode, until override_url_until. Set automatically for meeting episodes (Live app replay); NULL for all other episodes.';

COMMENT ON COLUMN "public"."episodes"."override_url_until" IS 'When override_url stops applying. NULL = no expiry.';

--- END ALTER TABLE "public"."episodes" ADD "override_url" / "override_url_until" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3108, 'episodes', 'override_url', NULL, 'input', NULL, NULL, NULL, true, false, 20, 'half', NULL, 'Set automatically from the meeting''s calendar entry (Live app replay link). Read-only.', NULL, false, 'configuration', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3109, 'episodes', 'override_url_until', NULL, 'datetime', NULL, 'datetime', NULL, true, false, 21, 'half', NULL, 'Set automatically: the meeting end + 48h. After this time the episode plays normally.', NULL, false, 'configuration', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 3108;

DELETE FROM "public"."directus_fields" WHERE "id" = 3109;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN ALTER TABLE "public"."episodes" DROP "override_url" / "override_url_until" ---

ALTER TABLE "public"."episodes" DROP COLUMN IF EXISTS "override_url";

ALTER TABLE "public"."episodes" DROP COLUMN IF EXISTS "override_url_until";

--- END ALTER TABLE "public"."episodes" DROP "override_url" / "override_url_until" ---
