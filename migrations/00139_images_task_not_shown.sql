-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-16T13:18:03.041Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = false, "conditions" = '[{"name":"show if image or link","rule":{"_and":[{"type":{"_nin":["image","link"]}}]},"hidden":true,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false},"required":null},{"name":"required if image","rule":{"_and":[{"type":{"_eq":"image"}}]},"required":true,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 887;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-16T13:18:04.640Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "hidden" = true, "conditions" = '[{"name":"show if image or link","rule":{"_and":[{"type":{"_in":["image","link"]}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false},"required":null},{"name":"required if image","rule":{"_and":[{"type":{"_eq":"image"}}]},"required":true,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 887;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
