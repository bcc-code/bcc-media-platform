-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2024-09-19T13:17:03.407Z            ***/
/**********************************************************/

ALTER TABLE IF EXISTS "public"."shorts" ADD COLUMN IF NOT EXISTS "score" float4 NULL DEFAULT '0'::real ;

COMMENT ON COLUMN "public"."shorts"."score"  IS NULL;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1486, 'shorts', 'score', NULL, NULL, '{"placeholder":"0.0","iconLeft":"scoreboard"}', NULL, NULL, true, true, 9, 'full', NULL, NULL, NULL, true, NULL, NULL, NULL);

-- +goose Down

ALTER TABLE IF EXISTS "public"."shorts" DROP COLUMN IF EXISTS "score" CASCADE;

DELETE FROM "public"."directus_fields" WHERE "id" = 1486;
