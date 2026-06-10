-- +goose Up

--- BEGIN ALTER TABLE "public"."calendarentries" ADD "buffer_start" / "buffer_end" ---

ALTER TABLE "public"."calendarentries" ADD COLUMN IF NOT EXISTS "buffer_start" timestamp NULL;

ALTER TABLE "public"."calendarentries" ADD COLUMN IF NOT EXISTS "buffer_end" timestamp NULL;

COMMENT ON COLUMN "public"."calendarentries"."buffer_start" IS 'Optional. Overrides the start of the buffer (start-over) playback URL. Independent of buffer_end; falls back to the entry start when unset. Ignored if the resulting window end is not after start.';

COMMENT ON COLUMN "public"."calendarentries"."buffer_end" IS 'Optional. Overrides the end of the buffer (start-over) playback URL. Independent of buffer_start; falls back to the entry end when unset. Ignored if the resulting window end is not after start.';

--- END ALTER TABLE "public"."calendarentries" ADD "buffer_start" / "buffer_end" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3106, 'calendarentries', 'buffer_start', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 22, 'half', NULL, 'Optional. Overrides the start of the buffer (start-over) playback URL. Can be set on its own or with buffer end. End must be after start, and should stay within ~30 min of the entry start. Leave empty to use the entry start.', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3107, 'calendarentries', 'buffer_end', NULL, 'datetime', NULL, 'datetime', NULL, false, false, 23, 'half', NULL, 'Optional. Overrides the end of the buffer (start-over) playback URL. Can be set on its own or with buffer start. Must be after the start, and should stay within ~30 min of the entry end. Leave empty to use the entry end.', NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 3106;

DELETE FROM "public"."directus_fields" WHERE "id" = 3107;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN ALTER TABLE "public"."calendarentries" DROP "buffer_start" / "buffer_end" ---

ALTER TABLE "public"."calendarentries" DROP COLUMN IF EXISTS "buffer_start";

ALTER TABLE "public"."calendarentries" DROP COLUMN IF EXISTS "buffer_end";

--- END ALTER TABLE "public"."calendarentries" DROP "buffer_start" / "buffer_end" ---
