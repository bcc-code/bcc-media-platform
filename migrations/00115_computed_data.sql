-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T13:46:48.407Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."computeddatagroups" ---

CREATE TABLE IF NOT EXISTS "public"."computeddatagroups"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "label"        varchar(255) NOT NULL,
    CONSTRAINT "computeddatagroups_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "computeddatagroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "computeddatagroups_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."computeddatagroups" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."computeddatagroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."computeddatagroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."computeddatagroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."computeddatagroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."computeddatagroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."computeddatagroups" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."computeddatagroups"."id" IS NULL;


COMMENT ON COLUMN "public"."computeddatagroups"."status" IS NULL;


COMMENT ON COLUMN "public"."computeddatagroups"."user_created" IS NULL;


COMMENT ON COLUMN "public"."computeddatagroups"."date_created" IS NULL;


COMMENT ON COLUMN "public"."computeddatagroups"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."computeddatagroups"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."computeddatagroups"."label" IS NULL;

COMMENT ON CONSTRAINT "computeddatagroups_user_created_foreign" ON "public"."computeddatagroups" IS NULL;


COMMENT ON CONSTRAINT "computeddatagroups_pkey" ON "public"."computeddatagroups" IS NULL;


COMMENT ON CONSTRAINT "computeddatagroups_user_updated_foreign" ON "public"."computeddatagroups" IS NULL;

COMMENT ON TABLE "public"."computeddatagroups" IS NULL;

--- END CREATE TABLE "public"."computeddatagroups" ---

--- BEGIN CREATE TABLE "public"."computeddata" ---

CREATE TABLE IF NOT EXISTS "public"."computeddata"
(
    "id"           uuid         NOT NULL,
    "status"       varchar(255) NOT NULL DEFAULT 'draft'::character varying,
    "user_created" uuid         NULL,
    "date_created" timestamptz  NULL,
    "user_updated" uuid         NULL,
    "date_updated" timestamptz  NULL,
    "group_id"     uuid         NOT NULL,
    "value"        varchar(255) NOT NULL,
    CONSTRAINT "computeddata_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users (id),
    CONSTRAINT "computeddata_group_id_foreign" FOREIGN KEY (group_id) REFERENCES computeddatagroups (id),
    CONSTRAINT "computeddata_pkey" PRIMARY KEY (id),
    CONSTRAINT "computeddata_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users (id)
);

GRANT SELECT ON TABLE "public"."computeddata" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."computeddata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."computeddata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."computeddata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."computeddata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."computeddata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."computeddata" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."computeddata"."id" IS NULL;


COMMENT ON COLUMN "public"."computeddata"."status" IS NULL;


COMMENT ON COLUMN "public"."computeddata"."user_created" IS NULL;


COMMENT ON COLUMN "public"."computeddata"."date_created" IS NULL;


COMMENT ON COLUMN "public"."computeddata"."user_updated" IS NULL;


COMMENT ON COLUMN "public"."computeddata"."date_updated" IS NULL;


COMMENT ON COLUMN "public"."computeddata"."group_id" IS NULL;


COMMENT ON COLUMN "public"."computeddata"."value" IS NULL;

COMMENT ON CONSTRAINT "computeddata_user_created_foreign" ON "public"."computeddata" IS NULL;


COMMENT ON CONSTRAINT "computeddata_group_id_foreign" ON "public"."computeddata" IS NULL;


COMMENT ON CONSTRAINT "computeddata_pkey" ON "public"."computeddata" IS NULL;


COMMENT ON CONSTRAINT "computeddata_user_updated_foreign" ON "public"."computeddata" IS NULL;

COMMENT ON TABLE "public"."computeddata" IS NULL;

--- END CREATE TABLE "public"."computeddata" ---

--- BEGIN CREATE TABLE "public"."computeddata_conditions" ---

CREATE TABLE IF NOT EXISTS "public"."computeddata_conditions"
(
    "id"              uuid         NOT NULL,
    "computeddata_id" uuid         NULL,
    "type"            varchar(255) NOT NULL,
    "operator"        varchar(255) NOT NULL DEFAULT NULL::character varying,
    "value"           varchar(255) NOT NULL,
    CONSTRAINT "computeddata_conditions_pkey" PRIMARY KEY (id),
    CONSTRAINT "computeddata_conditions_computeddata_id_foreign" FOREIGN KEY (computeddata_id) REFERENCES computeddata (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."computeddata_conditions" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."computeddata_conditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."computeddata_conditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."computeddata_conditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."computeddata_conditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."computeddata_conditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."computeddata_conditions" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."computeddata_conditions"."id" IS NULL;


COMMENT ON COLUMN "public"."computeddata_conditions"."computeddata_id" IS NULL;


COMMENT ON COLUMN "public"."computeddata_conditions"."type" IS NULL;


COMMENT ON COLUMN "public"."computeddata_conditions"."operator" IS NULL;


COMMENT ON COLUMN "public"."computeddata_conditions"."value" IS NULL;

COMMENT ON CONSTRAINT "computeddata_conditions_pkey" ON "public"."computeddata_conditions" IS NULL;


COMMENT ON CONSTRAINT "computeddata_conditions_computeddata_id_foreign" ON "public"."computeddata_conditions" IS NULL;

COMMENT ON TABLE "public"."computeddata_conditions" IS NULL;

--- END CREATE TABLE "public"."computeddata_conditions" ---

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links"
    ADD COLUMN IF NOT EXISTS "computeddatagroup_id" uuid NULL;

COMMENT ON COLUMN "public"."links"."computeddatagroup_id" IS NULL;

ALTER TABLE IF EXISTS "public"."links"
    ADD CONSTRAINT "links_computeddatagroup_id_foreign" FOREIGN KEY (computeddatagroup_id) REFERENCES computeddatagroups (id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "links_computeddatagroup_id_foreign" ON "public"."links" IS NULL;

--- END ALTER TABLE "public"."links" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections"
SET "sort" = 18
WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections"
SET "sort" = 19
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "sort" = 20
WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 24
WHERE "collection" = 'translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('computeddata', 'computer', NULL, '{{value}}', false, false, '[
  {
    "language": "en-US",
    "translation": "Computed Data",
    "singular": "Computed Data",
    "plural": "Computed Data"
  }
]', 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 9, NULL, 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('computeddatagroups', NULL, NULL, '{{label}}', false, false, '[
  {
    "language": "en-US",
    "translation": "Groups",
    "singular": "Group",
    "plural": "Groups"
  }
]', 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'computeddata', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton",
                                             "translations", "archive_field", "archive_app_filter", "archive_value",
                                             "unarchive_value", "sort_field", "accountability", "color",
                                             "item_duplication_fields", "sort", "group", "collapse")
VALUES ('computeddata_conditions', NULL, NULL, '{{type}} {{operator}} {{value}}', true, false, NULL, NULL, true, NULL,
        NULL, NULL, 'all', NULL, NULL, 1, 'computeddata', 'open');

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'lists_relations';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1023, 'computeddatagroups', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1025, 'computeddata', 'group_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false,
        NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1029, 'computeddata_conditions', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL,
        NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1031, 'computeddata', 'computeddata_conditions', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, NULL,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1027, 'computeddata', 'value', NULL, 'input', '{
  "choices": null
}', 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1028, 'computeddatagroups', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL,
        'Internal field', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1030, 'computeddata_conditions', 'computeddata_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL,
        false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1035, 'links', 'computeddatagroup_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false,
        10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields"
SET "sort" = 8
WHERE "id" = 644;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1032, 'computeddata_conditions', 'type', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "User -> Church",
      "value": "user_church"
    },
    {
      "text": "User -> Age",
      "value": "user_age"
    }
  ]
}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1019, 'computeddatagroups', 'status', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "$t:published",
      "value": "published"
    },
    {
      "text": "$t:draft",
      "value": "draft"
    },
    {
      "text": "$t:archived",
      "value": "archived"
    }
  ]
}', 'labels', '{
  "showAsDot": true,
  "choices": [
    {
      "text": "$t:published",
      "value": "published",
      "foreground": "#FFFFFF",
      "background": "var(--primary)"
    },
    {
      "text": "$t:draft",
      "value": "draft",
      "foreground": "#18222F",
      "background": "#D3DAE4"
    },
    {
      "text": "$t:archived",
      "value": "archived",
      "foreground": "#FFFFFF",
      "background": "var(--warning)"
    }
  ]
}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1022, 'computeddatagroups', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1012, 'computeddata', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1013, 'computeddata', 'status', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "$t:published",
      "value": "published"
    },
    {
      "text": "$t:draft",
      "value": "draft"
    },
    {
      "text": "$t:archived",
      "value": "archived"
    }
  ]
}', 'labels', '{
  "showAsDot": true,
  "choices": [
    {
      "text": "$t:published",
      "value": "published",
      "foreground": "#FFFFFF",
      "background": "var(--primary)"
    },
    {
      "text": "$t:draft",
      "value": "draft",
      "foreground": "#18222F",
      "background": "#D3DAE4"
    },
    {
      "text": "$t:archived",
      "value": "archived",
      "foreground": "#FFFFFF",
      "background": "var(--warning)"
    }
  ]
}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1014, 'computeddata', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1015, 'computeddata', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1016, 'computeddata', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1017, 'computeddata', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1034, 'computeddata_conditions', 'value', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1036, 'computeddatagroups', 'links', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, NULL, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1026, 'computeddatagroups', 'computeddata', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 8,
        'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1018, 'computeddatagroups', 'id', 'uuid', 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL,
        false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1020, 'computeddatagroups', 'user_created', 'user-created', 'select-dropdown-m2o', '{
  "template": "{{avatar.$thumbnail}} {{first_name}} {{last_name}}"
}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1021, 'computeddatagroups', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{
  "relative": true
}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (1033, 'computeddata_conditions', 'operator', NULL, 'select-dropdown', '{
  "choices": [
    {
      "text": "Equals",
      "value": "=="
    },
    {
      "text": "Less Than",
      "value": "<"
    }
  ]
}', NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (315, 'computeddatagroups', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (316, 'computeddata', 'group_id', 'computeddatagroups', 'computeddata', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (318, 'links', 'computeddatagroup_id', 'computeddatagroups', 'links', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (312, 'computeddata', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (313, 'computeddata', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (314, 'computeddatagroups', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field",
                                           "one_collection_field", "one_allowed_collections", "junction_field",
                                           "sort_field", "one_deselect_action")
VALUES (317, 'computeddata_conditions', 'computeddata_id', 'computeddata', 'computeddata_conditions', NULL, NULL, NULL,
        NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-01-05T13:46:49.795Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."links" ---

ALTER TABLE IF EXISTS "public"."links"
    DROP COLUMN IF EXISTS "computeddatagroup_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."links"
    DROP CONSTRAINT IF EXISTS "links_computeddatagroup_id_foreign";

--- END ALTER TABLE "public"."links" ---

--- BEGIN DROP TABLE "public"."computeddata_conditions" ---

DROP TABLE IF EXISTS "public"."computeddata_conditions";

--- END DROP TABLE "public"."computeddata_conditions" ---

--- BEGIN DROP TABLE "public"."computeddata" ---

DROP TABLE IF EXISTS "public"."computeddata";

--- END DROP TABLE "public"."computeddata" ---

--- BEGIN DROP TABLE "public"."computeddatagroups" ---

DROP TABLE IF EXISTS "public"."computeddatagroups";

--- END DROP TABLE "public"."computeddatagroups" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections"
SET "sort" = 9
WHERE "collection" = 'config';

UPDATE "public"."directus_collections"
SET "sort" = 10
WHERE "collection" = 'messages';

UPDATE "public"."directus_collections"
SET "sort" = 23
WHERE "collection" = 'translations';

UPDATE "public"."directus_collections"
SET "sort" = 15
WHERE "collection" = 'assetstreams_audio_languages';

UPDATE "public"."directus_collections"
SET "sort" = 16
WHERE "collection" = 'assetstreams_subtitle_languages';

UPDATE "public"."directus_collections"
SET "sort" = 17
WHERE "collection" = 'materialized_views_meta';

UPDATE "public"."directus_collections"
SET "sort" = 18
WHERE "collection" = 'applications_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 8
WHERE "collection" = 'notifications';

UPDATE "public"."directus_collections"
SET "sort" = 11
WHERE "collection" = 'seasons_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 12
WHERE "collection" = 'shows_usergroups';

UPDATE "public"."directus_collections"
SET "sort" = 13
WHERE "collection" = 'episodes_categories';

UPDATE "public"."directus_collections"
SET "sort" = 14
WHERE "collection" = 'lists_relations';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'computeddatagroups';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'computeddata_conditions';

DELETE
FROM "public"."directus_collections"
WHERE "collection" = 'computeddata';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields"
SET "sort" = 7
WHERE "id" = 644;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1023;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1025;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1029;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1031;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1027;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1028;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1030;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1035;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1032;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1019;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1022;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1012;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1013;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1014;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1015;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1016;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1017;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1034;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1036;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1026;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1018;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1020;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1021;

DELETE
FROM "public"."directus_fields"
WHERE "id" = 1033;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE
FROM "public"."directus_relations"
WHERE "id" = 315;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 316;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 318;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 312;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 313;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 314;

DELETE
FROM "public"."directus_relations"
WHERE "id" = 317;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
