-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T11:37:51.589Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Item",
      "value": "item"
    },
    {
      "text": "Message",
      "value": "message"
    },
    {
      "text": "Embed (Web)",
      "value": "embed_web"
    },
    {
      "text": "Achievements",
      "value": "achievements"
    },
    {
      "text": "Page Details",
      "value": "page_details"
    }
  ]
}'
WHERE "id" = 536;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T11:37:53.073Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "options" = '{
  "choices": [
    {
      "text": "Item",
      "value": "item"
    },
    {
      "text": "Message",
      "value": "message"
    },
    {
      "text": "Embed (Web)",
      "value": "embed_web"
    },
    {
      "text": "Achievements",
      "value": "achievements"
    }
  ]
}'
WHERE "id" = 536;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
