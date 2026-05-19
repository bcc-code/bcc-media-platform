-- +goose Up

-- The songs_translations table is unused: zero rows in production and no
-- application code references it. The translations widget on the Songs
-- admin form only contributes a duplicate "Title" field, so hide it.
UPDATE "public"."directus_fields"
   SET "hidden" = true
 WHERE "collection" = 'songs' AND "field" = 'translations';

-- +goose Down
UPDATE "public"."directus_fields"
   SET "hidden" = false
 WHERE "collection" = 'songs' AND "field" = 'translations';
