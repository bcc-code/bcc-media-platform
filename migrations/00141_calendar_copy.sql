-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-22T11:03:59.281Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "item_duplication_fields" = '["start","end","translations.title","translations.languages_code","translations.description"]' WHERE "collection" = 'events';

UPDATE "public"."directus_collections" SET "item_duplication_fields" = '["translations.languages_code","translations.title","start","end","image","event_id","translations.description","link_type","episode_id","season_id","show_id","image_from_link","is_replay"]' WHERE "collection" = 'calendarentries';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-22T11:04:00.750Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "item_duplication_fields" = NULL WHERE "collection" = 'calendarentries';

UPDATE "public"."directus_collections" SET "item_duplication_fields" = NULL WHERE "collection" = 'events';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
