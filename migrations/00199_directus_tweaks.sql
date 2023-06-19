-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-19T09:03:59.999Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('achievements_group', 'stars', NULL, NULL, false, false, '[
  {
    "language": "en-US",
    "translation": "Achievements"
  }
]', NULL, true, NULL, NULL, NULL, 'all', '#3399FF', NULL, 6, NULL, 'open', NULL);

UPDATE "public"."directus_collections"
SET "color" = NULL,
    "sort"  = 2,
    "group" = 'achievements_group'
WHERE "collection" = 'achievements';

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'usergroups';

UPDATE "public"."directus_collections"
SET "group" = 'achievements_group'
WHERE "collection" = 'achievementgroups';

UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'achievements_images';

UPDATE "public"."directus_collections"
SET "translations" = '[
  {
    "language": "en-US",
    "translation": "Entries",
    "singular": "Entry",
    "plural": "Entries"
  }
]'
WHERE "collection" = 'calendarentries';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'usergroups'
WHERE "collection" = 'usergroups_relations';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'episodes_usergroups_download';

UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'targets';

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'episodes_usergroups_earlyaccess';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'ageratings';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'lessons_images';

UPDATE "public"."directus_collections"
SET "sort"  = 3,
    "group" = 'studies'
WHERE "collection" = 'tasks';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'questionalternatives';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'messagetemplates';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'episodes'
WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'languages';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'redirects';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'achievementconditions'
WHERE "collection" = 'achievementconditions_studytopics';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'lists'
WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'assetstreams'
WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'assetstreams'
WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'lessons'
WHERE "collection" = 'lessons_relations';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'tasks'
WHERE "collection" = 'tasks_images';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'images';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'translations';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'styledimages';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'notifications'
WHERE "collection" = 'notifications_targets';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'games'
WHERE "collection" = 'games_styledimages';

UPDATE "public"."directus_collections"
SET "group" = 'messages_group'
WHERE "collection" = 'prompts';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'prompts'
WHERE "collection" = 'prompts_targets';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-19T09:04:01.847Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'ageratings';

UPDATE "public"."directus_collections"
SET "translations" = NULL
WHERE "collection" = 'calendarentries';

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'episodes_usergroups_download';

UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'messagetemplates';

UPDATE "public"."directus_collections"
SET "sort" = 5
WHERE "collection" = 'usergroups';

UPDATE "public"."directus_collections"
SET "group" = 'achievements'
WHERE "collection" = 'achievementgroups';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'episodes_usergroups_earlyaccess';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'targets';

UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'questionalternatives';

UPDATE "public"."directus_collections"
SET "color" = '#FFA439',
    "sort"  = 6,
    "group" = NULL
WHERE "collection" = 'achievements';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'achievements_images';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'lessons'
WHERE "collection" = 'tasks';

UPDATE "public"."directus_collections"
SET "sort" = 1
WHERE "collection" = 'lessons_images';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'languages';

UPDATE "public"."directus_collections"
SET "sort" = 18
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "group" = 'config'
WHERE "collection" = 'prompts';

UPDATE "public"."directus_collections"
SET "sort"  = 17,
    "group" = NULL
WHERE "collection" = 'usergroups_relations';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'redirects';

UPDATE "public"."directus_collections"
SET "sort"  = 13,
    "group" = NULL
WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections"
SET "sort"  = 14,
    "group" = NULL
WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections"
SET "sort"  = 15,
    "group" = NULL
WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections"
SET "sort"  = 16,
    "group" = NULL
WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections"
SET "sort" = 19
WHERE "collection" = 'images';

UPDATE "public"."directus_collections"
SET "sort"  = 20,
    "group" = NULL
WHERE "collection" = 'lessons_relations';

UPDATE "public"."directus_collections"
SET "sort"  = 21,
    "group" = NULL
WHERE "collection" = 'tasks_images';

UPDATE "public"."directus_collections"
SET "sort" = 22
WHERE "collection" = 'translations';

UPDATE "public"."directus_collections"
SET "sort"  = 23,
    "group" = NULL
WHERE "collection" = 'notifications_targets';

UPDATE "public"."directus_collections"
SET "sort"  = 24,
    "group" = NULL
WHERE "collection" = 'prompts_targets';

UPDATE "public"."directus_collections"
SET "sort"  = 25,
    "group" = NULL
WHERE "collection" = 'achievementconditions_studytopics';

UPDATE "public"."directus_collections"
SET "sort"  = 26,
    "group" = NULL
WHERE "collection" = 'games_styledimages';

UPDATE "public"."directus_collections"
SET "sort" = 27
WHERE "collection" = 'styledimages';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'achievements_group';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
