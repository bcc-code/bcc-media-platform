-- +goose Up

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "banner_source" varchar(255) NULL;

COMMENT ON COLUMN "public"."sections"."banner_source" IS 'Where a banner section gets its content from, e.g. live: the meeting on air, linking to the Live app.';

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- Blocks new fields (inserts take their id from the sequence) until this
-- migration commits, so none can be numbered between reading and resetting the
-- sequence below. Reads are not blocked.
LOCK TABLE "public"."directus_fields" IN EXCLUSIVE MODE;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (3111, 'sections', 'banner_source', NULL, 'select-dropdown', '{"choices":[{"text":"Live","value":"live"}]}', NULL, NULL, false, true, 6, 'half', NULL,
  'Where the banner content comes from. Live: shown to members while a meeting is on air, linking to the Live app.',
  '[{"name":"Show if Banner","rule":{"_and":[{"type":{"_eq":"banner"}}]},"hidden":false,"required":true,"options":{"allowOther":false,"allowNone":false}}]'::json,
  false, 'configuration', NULL, NULL);

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    { "text": "Item", "value": "item" },
    { "text": "Message", "value": "message" },
    { "text": "Embed (Web)", "value": "embed_web" },
    { "text": "Achievements", "value": "achievements" },
    { "text": "Page Details", "value": "page_details" },
    { "text": "Playlist", "value": "playlist" },
    { "text": "Banner", "value": "banner" }
  ]
}'::json
WHERE "id" = 536;

-- Earlier migrations inserted fields with explicit ids without moving the id
-- sequence, so new fields created in Directus would collide. Move it forward
-- past the highest id, but never backwards. Relies on the lock above: only
-- inserts into directus_fields use this sequence.
SELECT setval('"public"."directus_fields_id_seq"',
              GREATEST((SELECT max("id") FROM "public"."directus_fields"),
                       (SELECT CASE WHEN is_called THEN last_value ELSE last_value - 1 END
                        FROM "public"."directus_fields_id_seq")),
              true);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 3111;

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    { "text": "Item", "value": "item" },
    { "text": "Message", "value": "message" },
    { "text": "Embed (Web)", "value": "embed_web" },
    { "text": "Achievements", "value": "achievements" },
    { "text": "Page Details", "value": "page_details" },
    { "text": "Playlist", "value": "playlist" }
  ]
}'::json
WHERE "id" = 536;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "banner_source";

--- END ALTER TABLE "public"."sections" ---
