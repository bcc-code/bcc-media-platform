-- +goose Up

UPDATE "public"."directus_fields" SET "readonly" = true WHERE "id" = 321;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Select","value":"select"},{"text":"Query","value":"query"},{"text":"Randomized Query","value":"randomized_query","icon":"person_play"}]}' WHERE "id" = 386;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"hidden if not query","rule":{"_and":[{"filter_type":{"_nin":["query","randomized_query"]}}]},"hidden":true,"options":{"fieldCollection":""}}]' WHERE "id" = 703;


-- +goose Down
/**********************************************************/

UPDATE "public"."directus_fields" SET "readonly" = false WHERE "id" = 321;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Select","value":"select"},{"text":"Query","value":"query"}]}' WHERE "id" = 386;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"hidden if not query","rule":{"_and":[{"filter_type":{"_neq":"query"}}]},"hidden":true,"options":{"fieldCollection":""}}]' WHERE "id" = 703;
