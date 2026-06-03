-- +goose Up

--- BEGIN ALTER TABLE "public"."globalconfig" ---
ALTER TABLE IF EXISTS "public"."globalconfig" ADD COLUMN IF NOT EXISTS "livestream_url" text NULL;
--- END ALTER TABLE "public"."globalconfig" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (3100, 'globalconfig', 'livestream_url', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, 'Livestream manifest URL signed on-demand and returned by the API liveStream query', NULL, false, NULL, NULL, NULL);
--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
DELETE FROM "public"."directus_fields" WHERE "id" = 3100;
--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN ALTER TABLE "public"."globalconfig" ---
ALTER TABLE IF EXISTS "public"."globalconfig" DROP COLUMN IF EXISTS "livestream_url";
--- END ALTER TABLE "public"."globalconfig" ---
