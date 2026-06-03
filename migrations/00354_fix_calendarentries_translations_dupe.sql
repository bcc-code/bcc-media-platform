-- +goose Up
-- The calendarentries translations interface (directus_fields id 424) has
-- userLanguage:true, which makes Directus auto-add a translation row for the
-- editor's own language on top of the default. Saving then attempts a duplicate
-- (calendarentries_id, languages_code) insert and fails with
-- "Value has to be unique". Same fix as 00352 did for sections (id 247).
UPDATE "public"."directus_fields"
SET "options" = '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"no","userLanguage":false}'::json
WHERE "id" = 424;

-- +goose Down
UPDATE "public"."directus_fields"
SET "options" = '{"languageField":"code","languageDirectionField":"code","defaultLanguage":"no","userLanguage":true}'::json
WHERE "id" = 424;
