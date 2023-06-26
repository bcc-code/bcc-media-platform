-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-16T12:58:52.100Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "group" = 'config'
WHERE "id" = 684;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 636;

UPDATE "public"."directus_fields"
SET "display" = 'image'
WHERE "id" = 130;

UPDATE "public"."directus_fields"
SET "options"         = '{
  "enableCreate": false,
  "template": "{{usergroups_code.name}}"
}',
    "display"         = 'related-values',
    "display_options" = '{
      "template": "{{usergroups_code.name}}"
    }'
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "options"         = '{
  "enableCreate": false,
  "template": "{{usergroups_code.name}}"
}',
    "display"         = 'related-values',
    "display_options" = '{
      "template": "{{usergroups_code.name}}"
    }'
WHERE "id" = 127;

UPDATE "public"."directus_fields"
SET "sort" = 9
WHERE "id" = 638;

UPDATE "public"."directus_fields"
SET "display"         = 'related-values',
    "display_options" = '{
      "template": "{{usergroups_code.name}}"
    }'
WHERE "id" = 126;

UPDATE "public"."directus_fields"
SET "display" = 'datetime'
WHERE "id" = 121;

UPDATE "public"."directus_fields"
SET "display" = 'datetime'
WHERE "id" = 139;

UPDATE "public"."directus_fields"
SET "sort" = 8
WHERE "id" = 637;

UPDATE "public"."directus_fields"
SET "display" = 'datetime'
WHERE "id" = 122;

UPDATE "public"."directus_fields"
SET "display" = 'datetime'
WHERE "id" = 204;

UPDATE "public"."directus_fields"
SET "group" = 'link'
WHERE "id" = 641;

UPDATE "public"."directus_fields"
SET "display" = 'datetime'
WHERE "id" = 205;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 639;

UPDATE "public"."directus_fields"
SET "display" = 'datetime'
WHERE "id" = 215;

UPDATE "public"."directus_fields"
SET "display" = 'related-values'
WHERE "id" = 208;

UPDATE "public"."directus_fields"
SET "interface" = 'list-o2m',
    "display"   = 'related-values'
WHERE "id" = 563;

UPDATE "public"."directus_fields"
SET "display" = 'related-values'
WHERE "id" = 274;

UPDATE "public"."directus_fields"
SET "display" = 'datetime'
WHERE "id" = 272;

UPDATE "public"."directus_fields"
SET "group" = 'link'
WHERE "id" = 558;

UPDATE "public"."directus_fields"
SET "sort" = 13
WHERE "id" = 642;

UPDATE "public"."directus_fields"
SET "display" = 'labels'
WHERE "id" = 146;

UPDATE "public"."directus_fields"
SET "note" = 'This is the title shown in social previews or in Google when searched for.'
WHERE "id" = 783;

UPDATE "public"."directus_fields"
SET "group" = 'metadata'
WHERE "id" = 1172;

UPDATE "public"."directus_fields"
SET "sort" = 17
WHERE "id" = 614;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 464;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 465;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 466;

UPDATE "public"."directus_fields"
SET "sort" = 17
WHERE "id" = 879;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 467;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 463;

UPDATE "public"."directus_fields"
SET "interface" = 'input'
WHERE "id" = 995;

UPDATE "public"."directus_fields"
SET "display" = 'related-values'
WHERE "id" = 831;

UPDATE "public"."directus_fields"
SET "group" = 'link'
WHERE "id" = 557;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 873;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 838;

UPDATE "public"."directus_fields"
SET "sort" = 8
WHERE "id" = 626;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 245;

UPDATE "public"."directus_fields"
SET "display" = 'datetime'
WHERE "id" = 782;

UPDATE "public"."directus_fields"
SET "group" = 'link'
WHERE "id" = 559;

UPDATE "public"."directus_fields"
SET "group" = 'link'
WHERE "id" = 625;

UPDATE "public"."directus_fields"
SET "sort" = 10
WHERE "id" = 898;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 942;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 633;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 635;

UPDATE "public"."directus_fields"
SET "sort" = 14
WHERE "id" = 613;

UPDATE "public"."directus_fields"
SET "group" = 'metadata'
WHERE "id" = 1173;

UPDATE "public"."directus_fields"
SET "display" = 'labels'
WHERE "id" = 536;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 940;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 941;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 634;

UPDATE "public"."directus_fields"
SET "sort" = 6
WHERE "id" = 947;

UPDATE "public"."directus_fields"
SET "sort" = 18
WHERE "id" = 891;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 943;

UPDATE "public"."directus_fields"
SET "sort" = 19
WHERE "id" = 887;

UPDATE "public"."directus_fields"
SET "sort" = 4
WHERE "id" = 1177;

UPDATE "public"."directus_fields"
SET "sort" = 5
WHERE "id" = 1178;

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 1179;

UPDATE "public"."directus_fields"
SET "display" = 'related-values',
    "sort"    = 8
WHERE "id" = 1184;

UPDATE "public"."directus_fields"
SET "sort" = 3
WHERE "id" = 1176;

UPDATE "public"."directus_fields"
SET "note" = 'Inherit roles and permissions from this'
WHERE "id" = 1183;

UPDATE "public"."directus_fields"
SET "sort" = 1
WHERE "id" = 1174;

UPDATE "public"."directus_fields"
SET "sort" = 2
WHERE "id" = 1175;

UPDATE "public"."directus_fields"
SET "sort" = 11
WHERE "id" = 1067;

UPDATE "public"."directus_fields"
SET "sort" = 12
WHERE "id" = 1078;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "icon" = 'join_inner'
WHERE "collection" = 'achievementgroups';

UPDATE "public"."directus_collections"
SET "display_template" = '{{start}}-{{label}}'
WHERE "collection" = 'calendarentries';

UPDATE "public"."directus_collections"
SET "hidden" = true
WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections"
SET "icon" = 'fiber_smart_record'
WHERE "collection" = 'computeddatagroups';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'episodes_usergroups_earlyaccess';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "display_template" = '{{collection}} {{action}} {{amount}}'
WHERE "collection" = 'achievementconditions';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('usergroups_relations', 'folder', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL,
        NULL, 17, NULL, 'open', NULL);

UPDATE "public"."directus_collections"
SET "group" = 'translations'
WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'usergroups_relations'
WHERE "collection" = 'episodes_usergroups';

UPDATE "public"."directus_collections"
SET "sort"  = 12,
    "group" = 'translations'
WHERE "collection" = 'links_translations';

UPDATE "public"."directus_collections"
SET "sort" = 2
WHERE "collection" = 'episodes_usergroups_download';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('faqs_group', 'question_exchange', NULL, NULL, false, false, '[
  {
    "language": "en-US",
    "translation": "FAQs"
  }
]', NULL, true, NULL, NULL, NULL, 'all', '#FFC23B', NULL, 9, NULL, 'open', NULL);


UPDATE "public"."directus_collections"
SET "translations" = '[
  {
    "language": "en-US",
    "translation": "Categories",
    "singular": "Category",
    "plural": "Categories"
  }
]',
    "group"        = 'faqs_group'
WHERE "collection" = 'faqcategories';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse", "preview_url")
VALUES ('notifications_group', 'circle_notifications', NULL, NULL, false, false, '[
  {
    "language": "en-US",
    "translation": "Notifications"
  }
]', NULL, true, NULL, NULL, NULL, 'all', '#E35169', NULL, 8, NULL, 'open', NULL);

UPDATE "public"."directus_collections"
SET "icon"         = 'assignment',
    "translations" = '[
      {
        "language": "en-US",
        "translation": "Templates",
        "singular": "Template",
        "plural": "Templates"
      }
    ]',
    "group"        = 'notifications_group'
WHERE "collection" = 'notificationtemplates';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'notifications_group'
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "collapse" = 'closed'
WHERE "collection" = 'computeddata';


UPDATE "public"."directus_collections"
SET "color" = '#E35169',
    "sort"  = 10,
    "group" = NULL
WHERE "collection" = 'applications';

UPDATE "public"."directus_collections"
SET "icon" = 'chat',
    "sort" = 12
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "sort"  = 1,
    "group" = 'collections'
WHERE "collection" = 'collections_entries';

UPDATE "public"."directus_collections"
SET "sort" = 6
WHERE "collection" = 'languages';

UPDATE "public"."directus_collections"
SET "sort"  = 3,
    "group" = 'usergroups_relations'
WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'redirects';

UPDATE "public"."directus_collections"
SET "sort"  = 4,
    "group" = 'usergroups_relations'
WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections"
SET "translations" = '[
  {
    "language": "en-US",
    "translation": "Questions",
    "singular": "Question",
    "plural": "Questions"
  }
]',
    "color"        = NULL,
    "sort"         = 2,
    "group"        = 'faqs_group'
WHERE "collection" = 'faqs';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections"
SET "group" = 'translations'
WHERE "collection" = 'studytopics_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 16,
    "group" = 'translations'
WHERE "collection" = 'lessons_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 17,
    "group" = 'translations'
WHERE "collection" = 'tasks_translations';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections"
SET "sort"  = 18,
    "group" = 'translations'
WHERE "collection" = 'games_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 19,
    "group" = 'translations'
WHERE "collection" = 'timedmetadata_translations';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections"
SET "sort"  = 20,
    "group" = 'translations'
WHERE "collection" = 'surveyquestions_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 21,
    "group" = 'translations'
WHERE "collection" = 'surveys_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 22,
    "group" = 'translations'
WHERE "collection" = 'faqs_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 23,
    "group" = 'translations'
WHERE "collection" = 'prompts_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 24,
    "group" = 'translations'
WHERE "collection" = 'faqcategories_translations';


UPDATE "public"."directus_collections"
SET "sort"  = 25,
    "group" = 'translations'
WHERE "collection" = 'questionalternatives_translations';

UPDATE "public"."directus_collections"
SET "translations" = '[
  {
    "language": "en-US",
    "translation": "Groups",
    "singular": "Group",
    "plural": "Groups"
  }
]'
WHERE "collection" = 'applicationgroups';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections"
SET "sort" = 19
WHERE "collection" = 'images';

UPDATE "public"."directus_collections"
SET "sort" = 20
WHERE "collection" = 'lessons_relations';

UPDATE "public"."directus_collections"
SET "sort" = 21
WHERE "collection" = 'tasks_images';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'usergroups_relations'
WHERE "collection" = 'applicationgroups_usergroups';

UPDATE "public"."directus_collections"
SET "sort"  = 5,
    "group" = 'usergroups_relations'
WHERE "collection" = 'faqs_usergroups';

UPDATE "public"."directus_collections"
SET "sort"  = 6,
    "group" = 'usergroups_relations'
WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections"
SET "sort"  = 7,
    "group" = 'usergroups_relations'
WHERE "collection" = 'targets_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 26
WHERE "collection" = 'achievements_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 8,
    "group" = 'usergroups_relations'
WHERE "collection" = 'games_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 22
WHERE "collection" = 'translations';

UPDATE "public"."directus_collections"
SET "sort" = 27
WHERE "collection" = 'achievementgroups_translations';

UPDATE "public"."directus_collections"
SET "sort" = 23
WHERE "collection" = 'notifications_targets';

UPDATE "public"."directus_collections"
SET "sort" = 24
WHERE "collection" = 'prompts_targets';

UPDATE "public"."directus_collections"
SET "sort" = 25
WHERE "collection" = 'achievementconditions_studytopics';

UPDATE "public"."directus_collections"
SET "sort" = 26
WHERE "collection" = 'games_styledimages';

UPDATE "public"."directus_collections"
SET "sort" = 27
WHERE "collection" = 'styledimages';


--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_field" = NULL
WHERE "id" = 55;

UPDATE "public"."directus_relations"
SET "one_field" = NULL
WHERE "id" = 302;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-06-16T12:58:54.024Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "hidden" = false
WHERE "collection" = 'globalconfig';

UPDATE "public"."directus_collections"
SET "sort"  = 2,
    "group" = 'episodes'
WHERE "collection" = 'episodes_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 3
WHERE "collection" = 'episodes_usergroups_download';

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "display_template" = NULL
WHERE "collection" = 'calendarentries';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'images';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'links_translations';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'collections_entries';

UPDATE "public"."directus_collections"
SET "sort" = 7
WHERE "collection" = 'languages';

UPDATE "public"."directus_collections"
SET "color" = NULL,
    "sort"  = 6,
    "group" = 'config'
WHERE "collection" = 'applications';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'questionalternatives_translations';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'tasks_images';

UPDATE "public"."directus_collections"
SET "icon" = NULL
WHERE "collection" = 'achievementgroups';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'tasks_translations';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'lessons_relations';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'lessons_translations';

UPDATE "public"."directus_collections"
SET "sort" = 4
WHERE "collection" = 'episodes_usergroups_earlyaccess';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'targets_usergroups';

UPDATE "public"."directus_collections"
SET "icon"         = NULL,
    "translations" = NULL,
    "group"        = 'notifications'
WHERE "collection" = 'notificationtemplates';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'redirects';

UPDATE "public"."directus_collections"
SET "display_template" = NULL
WHERE "collection" = 'achievementconditions';

UPDATE "public"."directus_collections"
SET "group" = NULL
WHERE "collection" = 'ageratings_translations';

UPDATE "public"."directus_collections"
SET "collapse" = 'open'
WHERE "collection" = 'computeddata';

UPDATE "public"."directus_collections"
SET "icon" = NULL,
    "sort" = 11
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "sort"  = 8,
    "group" = NULL
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "sort" = 19
WHERE "collection" = 'achievements_translations';

UPDATE "public"."directus_collections"
SET "sort" = 20
WHERE "collection" = 'achievementgroups_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 12,
    "group" = NULL
WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections"
SET "sort"  = 13,
    "group" = NULL
WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'notifications_targets';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'lists_relations';

UPDATE "public"."directus_collections"
SET "icon" = NULL
WHERE "collection" = 'computeddatagroups';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections"
SET "sort"  = 19,
    "group" = NULL
WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 23
WHERE "collection" = 'translations';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'surveys_translations';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'surveyquestions_translations';

UPDATE "public"."directus_collections"
SET "sort" = 26
WHERE "collection" = 'prompts_targets';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'prompts_translations';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'achievementconditions_studytopics';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'faqcategories_translations';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'faqs_usergroups';

UPDATE "public"."directus_collections"
SET "translations" = NULL,
    "color"        = '#2ECDA7',
    "sort"         = 9,
    "group"        = NULL
WHERE "collection" = 'faqs';

UPDATE "public"."directus_collections"
SET "translations" = NULL,
    "group"        = 'faqs'
WHERE "collection" = 'faqcategories';

UPDATE "public"."directus_collections"
SET "sort"  = 30,
    "group" = NULL
WHERE "collection" = 'faqs_translations';

UPDATE "public"."directus_collections"
SET "translations" = NULL
WHERE "collection" = 'applicationgroups';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'applicationgroups_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'styledimages';

UPDATE "public"."directus_collections"
SET "sort"  = 35,
    "group" = NULL
WHERE "collection" = 'games_translations';

UPDATE "public"."directus_collections"
SET "sort"  = 36,
    "group" = NULL
WHERE "collection" = 'games_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = NULL
WHERE "collection" = 'games_styledimages';

UPDATE "public"."directus_collections"
SET "sort"  = NULL,
    "group" = NULL
WHERE "collection" = 'timedmetadata_translations';

UPDATE "public"."directus_collections"
SET "group" = NULL
WHERE "collection" = 'studytopics_translations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'usergroups_relations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'faqs_group';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'notifications_group';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 139;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 121;

UPDATE "public"."directus_fields"
SET "display"         = NULL,
    "display_options" = NULL
WHERE "id" = 126;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 130;

UPDATE "public"."directus_fields"
SET "options"         = '{
  "enableCreate": false
}',
    "display"         = NULL,
    "display_options" = NULL
WHERE "id" = 149;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 215;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 205;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 204;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 274;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 272;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 464;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 465;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 466;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 467;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 463;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 641;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 208;

UPDATE "public"."directus_fields"
SET "group" = 'configuration'
WHERE "id" = 245;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 614;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 626;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 559;

UPDATE "public"."directus_fields"
SET "interface" = NULL,
    "display"   = NULL
WHERE "id" = 563;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 637;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 638;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 639;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 636;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 613;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 558;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 557;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 625;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 642;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 633;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 634;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 635;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 536;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 684;

UPDATE "public"."directus_fields"
SET "options"         = '{
  "enableCreate": false
}',
    "display"         = NULL,
    "display_options" = NULL
WHERE "id" = 127;

UPDATE "public"."directus_fields"
SET "note" = NULL
WHERE "id" = 783;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 122;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 873;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 838;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 831;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 782;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 879;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 940;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 947;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 941;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 898;

UPDATE "public"."directus_fields"
SET "interface" = NULL
WHERE "id" = 995;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 891;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 887;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 1067;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 1078;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 942;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 943;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 1174;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 1175;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 1177;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 1178;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 1179;

UPDATE "public"."directus_fields"
SET "display" = NULL,
    "sort"    = NULL
WHERE "id" = 1184;

UPDATE "public"."directus_fields"
SET "note" = NULL
WHERE "id" = 1183;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 1172;

UPDATE "public"."directus_fields"
SET "sort" = NULL
WHERE "id" = 1176;

UPDATE "public"."directus_fields"
SET "display" = NULL
WHERE "id" = 146;

UPDATE "public"."directus_fields"
SET "group" = NULL
WHERE "id" = 1173;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations"
SET "one_field" = 'episode_earlyaccess'
WHERE "id" = 55;

UPDATE "public"."directus_relations"
SET "one_field" = 'notifications'
WHERE "id" = 302;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
