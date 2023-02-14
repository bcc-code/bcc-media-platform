-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-14T12:18:31.868Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 886;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if image or link","rule":{"_and":[{"type":{"_in":["image","link"]}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false},"required":null},{"name":"required if image","rule":{"_and":[{"type":{"_eq":"image"}}]},"required":true,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 887;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-14T12:18:33.282Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 886;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if image or link","rule":{"_and":[{"type":{"_in":["image","link"]}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false},"required":true}]' WHERE "id" = 887;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
