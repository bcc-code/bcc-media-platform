-- +goose Up

-- Register songs.date_updated and songs_translations.date_updated in
-- directus_fields so the admin treats them like every other collection's
-- date_updated: hidden, readonly, and auto-filled on update. Without these
-- rows Directus discovers the columns and renders them as editable inputs,
-- producing a duplicated "Date Updated" field at the top of the Songs form
-- and another inside the translations sub-form.
INSERT INTO "public"."directus_fields"
  ("id", "collection", "field", "special", "interface", "options", "display",
   "display_options", "readonly", "hidden", "sort", "width", "translations",
   "note", "conditions", "required", "group", "validation", "validation_message")
VALUES
  (3097, 'songs', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime',
   '{"relative":true}', true, true, 8, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL),
  (3098, 'songs_translations', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime',
   '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

-- +goose Down
DELETE FROM "public"."directus_fields" WHERE "id" IN (3097, 3098);
