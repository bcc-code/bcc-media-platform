-- +goose Up

--- BEGIN ALTER TABLE "public"."sections" ---
ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "playlist_id" uuid NULL;
ALTER TABLE IF EXISTS "public"."sections"
    ADD CONSTRAINT "sections_playlist_id_foreign" FOREIGN KEY (playlist_id) REFERENCES playlists(id) ON DELETE SET NULL;
COMMENT ON CONSTRAINT "sections_playlist_id_foreign" ON "public"."sections" IS NULL;
--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (3099, 'sections', 'playlist_id', 'm2o', 'select-dropdown-m2o', '{"template":"{{title}}"}', NULL, NULL, false, false, NULL, 'full', NULL, NULL,
  '[{"name":"Show if Playlist","rule":{"_and":[{"type":{"_eq":"playlist"}}]},"hidden":false,"required":true,"options":{"enableCreate":false,"enableSelect":true}}]'::json,
  false, NULL, NULL, NULL);

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

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")
VALUES (493, 'sections', 'playlist_id', 'playlists', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
DELETE FROM "public"."directus_relations" WHERE "id" = 493;
--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
DELETE FROM "public"."directus_fields" WHERE "id" = 3099;

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    { "text": "Item", "value": "item" },
    { "text": "Message", "value": "message" },
    { "text": "Embed (Web)", "value": "embed_web" },
    { "text": "Achievements", "value": "achievements" },
    { "text": "Page Details", "value": "page_details" }
  ]
}'::json
WHERE "id" = 536;
--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN ALTER TABLE "public"."sections" ---
ALTER TABLE IF EXISTS "public"."sections" DROP CONSTRAINT IF EXISTS "sections_playlist_id_foreign";
ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "playlist_id";
--- END ALTER TABLE "public"."sections" ---
