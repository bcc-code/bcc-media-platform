-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-08-01T07:58:53.024Z            ***/
/**********************************************************/
ALTER TABLE IF EXISTS "public"."applicationgroups" ADD COLUMN IF NOT EXISTS "web_prefix" varchar(255) NULL  ;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3084, 'applicationgroups', 'web_prefix', NULL, 'input', '{"placeholder":"https://app.bcc.media","iconLeft":"http","trim":true}', NULL, NULL, false, false, 15, 'full', NULL, 'For example "https://app.bcc.media". No trailing slash', NULL, false, NULL, '{"_and":[{"web_prefix":{"_regex":"^https?:\\/\\/[^\\s\\/]+(?::\\d+)?(?:\\/.*)?(?<!\\/)$"}}]}', NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true) FROM "public"."directus_fields";

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2025-08-01T07:58:54.347Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."applicationgroups" DROP COLUMN IF EXISTS "web_prefix" CASCADE; --WARN: Drop column can occure in data loss!

DELETE FROM "public"."directus_fields" WHERE "id" = 3084;
