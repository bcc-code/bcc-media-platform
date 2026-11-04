-- +goose Up

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    { "text": "Item", "value": "item" },
    { "text": "Message", "value": "message" },
    { "text": "Embed (Web)", "value": "embed_web" },
    { "text": "Achievements", "value": "achievements" },
    { "text": "Page Details", "value": "page_details" },
    { "text": "Playlist", "value": "playlist" },
    { "text": "Live", "value": "live" }
  ]
}'::json
WHERE "id" = 536;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

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
