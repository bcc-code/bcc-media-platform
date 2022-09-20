-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-20T09:40:06.777Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Hide when standalone","rule":{"_and":[{"type":{"_eq":"standalone"}}]},"hidden":true,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}},{"name":"Required when episode","rule":{"_and":[{"type":{"_eq":"episode"}}]},"required":true,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]' WHERE "id" = 128;

UPDATE "public"."directus_fields" SET "hidden" = false, "conditions" = '[{"name":"Hidden when episode","rule":{"_and":[{"type":{"_eq":"episode"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true}}]' WHERE "id" = 118;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-20T09:40:08.060Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = true, "conditions" = NULL WHERE "id" = 118;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Hide when standalone","rule":{"_and":[{"type":{"_eq":"standalone"}}]},"hidden":true}]' WHERE "id" = 128;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
