-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-28T13:34:08.049Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."calendarentries" ---

ALTER TABLE IF EXISTS "public"."calendarentries" ADD COLUMN IF NOT EXISTS "label" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."calendarentries"."label"  IS NULL;

--- END ALTER TABLE "public"."calendarentries" ---

--- BEGIN DROP TABLE "public"."tvguideentry" ---

DROP TABLE IF EXISTS "public"."tvguideentry";

--- END DROP TABLE "public"."tvguideentry" ---

--- BEGIN DROP TABLE "public"."calendarevent" ---

DROP TABLE IF EXISTS "public"."calendarevent";

--- END DROP TABLE "public"."calendarevent" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "icon" = 'tag' WHERE "collection" = 'tags';

UPDATE "public"."directus_collections" SET "hidden" = true WHERE "collection" = 'lists';

UPDATE "public"."directus_collections" SET "translations" = '[{"language":"en-US","translation":"Questions","singular":"Question","plural":"Questions"}]' WHERE "collection" = 'surveyquestions';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'tvguideentry';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'calendarevent';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 424;

UPDATE "public"."directus_fields" SET "hidden" = false, "width" = 'half' WHERE "id" = 415;

UPDATE "public"."directus_fields" SET "sort" = 10, "width" = 'half' WHERE "id" = 422;

UPDATE "public"."directus_fields" SET "sort" = 11, "width" = 'half' WHERE "id" = 412;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 418;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 416;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1084;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1093, 'calendarentries', 'label', NULL, 'input', NULL, 'raw', NULL, false, false, 7, 'full', NULL, 'For internal use', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 765;

UPDATE "public"."directus_fields" SET "width" = 'half' WHERE "id" = 423;

UPDATE "public"."directus_fields" SET "sort" = 9, "translations" = '[{"language":"en-US","translation":"Questions"}]' WHERE "id" = 1066;

DELETE FROM "public"."directus_fields" WHERE "id" = 62;

DELETE FROM "public"."directus_fields" WHERE "id" = 63;

DELETE FROM "public"."directus_fields" WHERE "id" = 64;

DELETE FROM "public"."directus_fields" WHERE "id" = 65;

DELETE FROM "public"."directus_fields" WHERE "id" = 66;

DELETE FROM "public"."directus_fields" WHERE "id" = 67;

DELETE FROM "public"."directus_fields" WHERE "id" = 68;

DELETE FROM "public"."directus_fields" WHERE "id" = 305;

DELETE FROM "public"."directus_fields" WHERE "id" = 306;

DELETE FROM "public"."directus_fields" WHERE "id" = 307;

DELETE FROM "public"."directus_fields" WHERE "id" = 308;

DELETE FROM "public"."directus_fields" WHERE "id" = 309;

DELETE FROM "public"."directus_fields" WHERE "id" = 311;

DELETE FROM "public"."directus_fields" WHERE "id" = 312;

DELETE FROM "public"."directus_fields" WHERE "id" = 313;

DELETE FROM "public"."directus_fields" WHERE "id" = 314;

DELETE FROM "public"."directus_fields" WHERE "id" = 315;

DELETE FROM "public"."directus_fields" WHERE "id" = 316;

DELETE FROM "public"."directus_fields" WHERE "id" = 60;

DELETE FROM "public"."directus_fields" WHERE "id" = 61;

DELETE FROM "public"."directus_fields" WHERE "id" = 303;

DELETE FROM "public"."directus_fields" WHERE "id" = 304;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 17;

DELETE FROM "public"."directus_relations" WHERE "id" = 18;

DELETE FROM "public"."directus_relations" WHERE "id" = 89;

DELETE FROM "public"."directus_relations" WHERE "id" = 90;

DELETE FROM "public"."directus_relations" WHERE "id" = 91;

DELETE FROM "public"."directus_relations" WHERE "id" = 92;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-28T13:34:09.567Z             ***/
/***********************************************************/


--- BEGIN CREATE TABLE "public"."calendarevent" ---

CREATE TABLE IF NOT EXISTS "public"."calendarevent" (
                                                        "date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
                                                        "date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
                                                        "end" timestamp NULL  ,
                                                        "id" int4 NOT NULL DEFAULT nextval('calendarevent_id_seq'::regclass) ,
                                                        "start" timestamp NOT NULL  ,
                                                        "status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
                                                        "title" varchar(255) NULL DEFAULT NULL::character varying ,
                                                        "user_created" uuid NULL  ,
                                                        "user_updated" uuid NULL  ,
                                                        CONSTRAINT "calendarevent_pkey" PRIMARY KEY (id) ,
                                                        CONSTRAINT "calendarevent_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
                                                        CONSTRAINT "calendarevent_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."calendarevent" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."calendarevent" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."calendarevent" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."calendarevent" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."calendarevent" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."calendarevent" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."calendarevent" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."calendarevent" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."calendarevent" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."calendarevent" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."calendarevent" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."calendarevent" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."calendarevent" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."calendarevent" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."calendarevent" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."calendarevent" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."calendarevent"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."end"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."id"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."start"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."status"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."title"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."calendarevent"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "calendarevent_pkey" ON "public"."calendarevent" IS NULL;


COMMENT ON CONSTRAINT "calendarevent_user_created_foreign" ON "public"."calendarevent" IS NULL;


COMMENT ON CONSTRAINT "calendarevent_user_updated_foreign" ON "public"."calendarevent" IS NULL;

COMMENT ON TABLE "public"."calendarevent"  IS NULL;

--- END CREATE TABLE "public"."calendarevent" ---


--- BEGIN CREATE TABLE "public"."tvguideentry" ---

CREATE TABLE IF NOT EXISTS "public"."tvguideentry" (
	"date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"description" varchar(255) NULL DEFAULT NULL::character varying ,
	"end" timestamp NULL  ,
	"event" int4 NULL  ,
	"id" int4 NOT NULL DEFAULT nextval('tvguideentry_id_seq'::regclass) ,
	"image" uuid NULL  ,
	"start" timestamp NULL  ,
	"status" varchar(255) NULL DEFAULT 'published'::character varying ,
	"title" varchar(255) NULL DEFAULT NULL::character varying ,
	"use_image_from_link" bool NOT NULL DEFAULT true ,
	"user_created" uuid NULL  ,
	"user_updated" uuid NULL  ,
	CONSTRAINT "tvguideentry_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "tvguideentry_event_foreign" FOREIGN KEY (event) REFERENCES calendarevent(id) ON DELETE SET NULL ,
	CONSTRAINT "tvguideentry_image_foreign" FOREIGN KEY (image) REFERENCES directus_files(id) ON DELETE SET NULL ,
	CONSTRAINT "tvguideentry_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "tvguideentry_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."tvguideentry" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."tvguideentry" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."tvguideentry" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."tvguideentry" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."tvguideentry" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."tvguideentry" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."tvguideentry" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT SELECT ON TABLE "public"."tvguideentry" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."tvguideentry" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."tvguideentry" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."tvguideentry" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."tvguideentry" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."tvguideentry" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."tvguideentry" TO builder; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."tvguideentry"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."description"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."end"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."event"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."id"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."image"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."start"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."status"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."title"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."use_image_from_link"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."tvguideentry"."user_updated"  IS NULL;

COMMENT ON CONSTRAINT "tvguideentry_pkey" ON "public"."tvguideentry" IS NULL;


COMMENT ON CONSTRAINT "tvguideentry_event_foreign" ON "public"."tvguideentry" IS NULL;


COMMENT ON CONSTRAINT "tvguideentry_image_foreign" ON "public"."tvguideentry" IS NULL;


COMMENT ON CONSTRAINT "tvguideentry_user_created_foreign" ON "public"."tvguideentry" IS NULL;


COMMENT ON CONSTRAINT "tvguideentry_user_updated_foreign" ON "public"."tvguideentry" IS NULL;

COMMENT ON TABLE "public"."tvguideentry"  IS NULL;

--- END CREATE TABLE "public"."tvguideentry" ---

--- BEGIN ALTER TABLE "public"."calendarentries" ---

ALTER TABLE IF EXISTS "public"."calendarentries" DROP COLUMN IF EXISTS "label" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."calendarentries" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('tvguideentry', 'calendar_view_day', NULL, '{{title}}', true, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 1, 'calendar', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('calendarevent', 'event', NULL, NULL, true, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 2, 'calendar', 'open');

UPDATE "public"."directus_collections" SET "icon" = 'label' WHERE "collection" = 'tags';

UPDATE "public"."directus_collections" SET "hidden" = false WHERE "collection" = 'lists';

UPDATE "public"."directus_collections" SET "translations" = NULL WHERE "collection" = 'surveyquestions';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (62, 'calendarevent', 'end', NULL, 'datetime', NULL, NULL, NULL, false, false, 9, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (63, 'calendarevent', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (64, 'calendarevent', 'start', NULL, 'datetime', NULL, NULL, NULL, false, false, 8, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (65, 'calendarevent', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (66, 'calendarevent', 'title', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (67, 'calendarevent', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (68, 'calendarevent', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (305, 'tvguideentry', 'description', NULL, 'input', '{"iconLeft":"description"}', NULL, NULL, false, false, 8, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (306, 'tvguideentry', 'end', NULL, 'datetime', NULL, NULL, NULL, false, false, 11, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (307, 'tvguideentry', 'event', 'm2o', 'select-dropdown-m2o', '{"template":"{{title}}"}', NULL, NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (308, 'tvguideentry', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (309, 'tvguideentry', 'image', 'file', 'file-image', '{"crop":false}', NULL, NULL, false, false, 14, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (311, 'tvguideentry', 'start', NULL, 'datetime', NULL, NULL, NULL, false, false, 10, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (312, 'tvguideentry', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}],"showAsDot":true}', false, false, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (313, 'tvguideentry', 'title', NULL, 'input', '{"iconLeft":"title"}', NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (314, 'tvguideentry', 'use_image_from_link', 'cast-boolean', 'boolean', '{"label":"Use image from link"}', NULL, NULL, false, false, 13, 'full', NULL, 'Will use the image from the linked episode if it has one.', NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (315, 'tvguideentry', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (316, 'tvguideentry', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (60, 'calendarevent', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (61, 'calendarevent', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (303, 'tvguideentry', 'date_created', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (304, 'tvguideentry', 'date_updated', 'date-created,date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 6, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 424;

UPDATE "public"."directus_fields" SET "hidden" = true, "width" = 'full' WHERE "id" = 415;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 416;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 418;

UPDATE "public"."directus_fields" SET "width" = 'full' WHERE "id" = 423;

UPDATE "public"."directus_fields" SET "sort" = 9, "width" = 'full' WHERE "id" = 422;

UPDATE "public"."directus_fields" SET "sort" = 10, "width" = 'full' WHERE "id" = 412;

UPDATE "public"."directus_fields" SET "sort" = 10, "translations" = NULL WHERE "id" = 1066;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1084;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 765;

DELETE FROM "public"."directus_fields" WHERE "id" = 1093;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (17, 'calendarevent', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (18, 'calendarevent', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (89, 'tvguideentry', 'event', 'calendarevent', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (90, 'tvguideentry', 'image', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (91, 'tvguideentry', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (92, 'tvguideentry', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
