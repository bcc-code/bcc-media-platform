-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-13T07:37:22.024Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'FAQ';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'achievements';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'computeddata';

UPDATE "public"."directus_collections" SET "sort" = 21 WHERE "collection" = 'achievements_translations';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'messages';

UPDATE "public"."directus_collections" SET "sort" = 22 WHERE "collection" = 'achievementgroups_translations';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'studies';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 18 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'studytopics_translations';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'messagetemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 19 WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 23 WHERE "collection" = 'translations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 20 WHERE "id" = 894;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if image","rule":{"_and":[{"type":{"_eq":"image"}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false},"required":true}]' WHERE "id" = 891;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if image or link","rule":{"_and":[{"type":{"_in":["image","link"]}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false},"required":true}]' WHERE "id" = 887;

UPDATE "public"."directus_fields" SET "sort" = 21 WHERE "id" = 895;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-13T07:37:23.586Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'main_content';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'page_management';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'calendar';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'asset_management';

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'FAQ';

UPDATE "public"."directus_collections" SET "sort" = 11 WHERE "collection" = 'config';

UPDATE "public"."directus_collections" SET "sort" = 8 WHERE "collection" = 'achievements';

UPDATE "public"."directus_collections" SET "sort" = 18 WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections" SET "sort" = 19 WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections" SET "sort" = 20 WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 24 WHERE "collection" = 'translations';

UPDATE "public"."directus_collections" SET "sort" = 21 WHERE "collection" = 'achievementgroups_translations';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'notificationtemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'studytopics_translations';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'messagetemplates_translations';

UPDATE "public"."directus_collections" SET "sort" = 20 WHERE "collection" = 'achievements_translations';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'studies';

UPDATE "public"."directus_collections" SET "sort" = 9 WHERE "collection" = 'computeddata';

UPDATE "public"."directus_collections" SET "sort" = 12 WHERE "collection" = 'messages';

UPDATE "public"."directus_collections" SET "sort" = 17 WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections" SET "sort" = 10 WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections" SET "sort" = 13 WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 14 WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 15 WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections" SET "sort" = 16 WHERE "collection" = 'lists_relations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if image","rule":{"_and":[{"type":{"_eq":"image"}}]},"hidden":false,"options":{"allowOther":false,"allowNone":false}}]' WHERE "id" = 891;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if image or link","rule":{"_and":[{"type":{"_in":["image","link"]}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 887;

UPDATE "public"."directus_fields" SET "sort" = 17 WHERE "id" = 894;

UPDATE "public"."directus_fields" SET "sort" = 18 WHERE "id" = 895;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
