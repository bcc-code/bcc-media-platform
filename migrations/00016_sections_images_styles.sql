-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-03T07:41:28.674Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."sections_links_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."sections_links_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."sections_links_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."sections_links_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."sections_links_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."sections_links_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."sections_links_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."images_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."images_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."images_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."images_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."images_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."images_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."images_id_seq" ---

--- BEGIN CREATE TABLE "public"."sections_links" ---

CREATE TABLE IF NOT EXISTS "public"."sections_links" (
	"id" int4 NOT NULL DEFAULT nextval('sections_links_id_seq'::regclass) ,
	"sort" int4 NULL  ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"page_id" int4 NULL  ,
	"url" varchar(255) NULL  ,
	"section_id" int4 NOT NULL  ,
	"icon" uuid NULL  ,
	CONSTRAINT "sections_links_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "sections_links_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "sections_links_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "sections_links_page_id_foreign" FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE SET NULL ,
	CONSTRAINT "sections_links_section_id_foreign" FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE ,
	CONSTRAINT "sections_links_icon_foreign" FOREIGN KEY (icon) REFERENCES directus_files(id) ON DELETE SET NULL
);

ALTER TABLE IF EXISTS "public"."sections_links" OWNER TO builder;

GRANT SELECT ON TABLE "public"."sections_links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."sections_links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."sections_links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."sections_links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

GRANT SELECT ON TABLE "public"."sections_links" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."sections_links"."id"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."sort"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."page_id"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."url"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."section_id"  IS NULL;


COMMENT ON COLUMN "public"."sections_links"."icon"  IS NULL;

COMMENT ON CONSTRAINT "sections_links_pkey" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_user_created_foreign" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_user_updated_foreign" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_page_id_foreign" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_section_id_foreign" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_icon_foreign" ON "public"."sections_links" IS NULL;

COMMENT ON TABLE "public"."sections_links"  IS NULL;

--- END CREATE TABLE "public"."sections_links" ---

--- BEGIN CREATE TABLE "public"."images" ---

CREATE TABLE IF NOT EXISTS "public"."images" (
	"id" int4 NOT NULL DEFAULT nextval('images_id_seq'::regclass) ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"show_id" int4 NULL  ,
	"season_id" int4 NULL  ,
	"episode_id" int4 NULL  ,
	"style" varchar(255) NOT NULL  ,
	"file" uuid NULL  ,
	"language" varchar(255) NOT NULL DEFAULT NULL::character varying ,
	CONSTRAINT "images_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "images_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "images_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "images_file_foreign" FOREIGN KEY (file) REFERENCES directus_files(id) ON DELETE SET NULL ,
	CONSTRAINT "images_language_foreign" FOREIGN KEY (language) REFERENCES languages(code) ,
	CONSTRAINT "images_show_id_foreign" FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE ,
	CONSTRAINT "images_season_id_foreign" FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE CASCADE ,
	CONSTRAINT "images_episode_id_foreign" FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE CASCADE
);

ALTER TABLE IF EXISTS "public"."images" OWNER TO builder;

GRANT SELECT ON TABLE "public"."images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."images" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

GRANT SELECT ON TABLE "public"."images" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."images"."id"  IS NULL;


COMMENT ON COLUMN "public"."images"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."images"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."images"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."images"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."images"."show_id"  IS NULL;


COMMENT ON COLUMN "public"."images"."season_id"  IS NULL;


COMMENT ON COLUMN "public"."images"."episode_id"  IS NULL;


COMMENT ON COLUMN "public"."images"."style"  IS NULL;


COMMENT ON COLUMN "public"."images"."file"  IS NULL;


COMMENT ON COLUMN "public"."images"."language"  IS NULL;

COMMENT ON CONSTRAINT "images_pkey" ON "public"."images" IS NULL;


COMMENT ON CONSTRAINT "images_user_created_foreign" ON "public"."images" IS NULL;


COMMENT ON CONSTRAINT "images_user_updated_foreign" ON "public"."images" IS NULL;


COMMENT ON CONSTRAINT "images_file_foreign" ON "public"."images" IS NULL;


COMMENT ON CONSTRAINT "images_language_foreign" ON "public"."images" IS NULL;


COMMENT ON CONSTRAINT "images_show_id_foreign" ON "public"."images" IS NULL;


COMMENT ON CONSTRAINT "images_season_id_foreign" ON "public"."images" IS NULL;


COMMENT ON CONSTRAINT "images_episode_id_foreign" ON "public"."images" IS NULL;

COMMENT ON TABLE "public"."images"  IS NULL;

--- END CREATE TABLE "public"."images" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "type" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."sections"."type"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "link_style" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."sections"."link_style"  IS NULL;

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "show_title" bool NULL DEFAULT true ;

COMMENT ON COLUMN "public"."sections"."show_title"  IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "hidden" = true WHERE "collection" = 'tvguideentry';

UPDATE "public"."directus_collections" SET "hidden" = true WHERE "collection" = 'calendarevent';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'sections_usergroups';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'sections_translations';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sections_links', NULL, NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 1, 'sections', 'open');

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('images', NULL, NULL, '{{language.code}} - {{style}}', false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 208;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 274;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 236;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 246;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Labels","value":"labels"}]}' WHERE "id" = 405;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 403;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 245;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (550, 'sections_links', 'icon', 'file', 'file-image', NULL, 'image', NULL, false, false, NULL, 'full', NULL, 'Should be set if Section->Link Style is icons', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (536, 'sections', 'type', NULL, 'select-dropdown', '{"choices":[{"text":"Item","value":"item"},{"text":"Link","value":"link"}]}', NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 247;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (537, 'sections', 'links', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, true, 4, 'full', NULL, NULL, '[{"name":"Shown if LinkSection","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{}}]', false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = true, "sort" = 5, "conditions" = '[{"name":"Shown if ItemSection","rule":{"_and":[{"type":{"_eq":"item"}}]},"hidden":false,"options":{"start":"open"}}]' WHERE "id" = 535;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (552, 'images', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (553, 'images', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (551, 'sections', 'show_title', 'cast-boolean', 'boolean', NULL, NULL, NULL, false, false, 1, 'full', NULL, 'Should the title and description be shown above the section?', NULL, false, 'translatable_details', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (540, 'sections_links', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (541, 'sections_links', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (542, 'sections_links', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (543, 'sections_links', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (544, 'sections_links', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (560, 'images', 'style', NULL, 'select-dropdown', '{"choices":[{"text":"Featured","value":"featured"},{"text":"Poster","value":"poster"},{"text":"Default","value":"default"},{"text":"Icon","value":"icon"}]}', 'labels', NULL, false, false, 9, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (562, 'images', 'language', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (554, 'images', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (539, 'sections_links', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (545, 'sections_links', 'metadata', 'alias,no-data,group', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (548, 'sections_links', 'section_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (546, 'sections_links', 'page_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4, 'full', NULL, 'Either this or URL must be specified', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (547, 'sections_links', 'url', NULL, 'input', NULL, NULL, NULL, false, false, 5, 'full', NULL, 'Required if Page is not set', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (538, 'sections', 'link_style', NULL, 'select-dropdown', '{"choices":[{"text":"Icons","value":"icons"},{"text":"Labels","value":"labels"}]}', 'labels', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'links', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (549, 'sections', 'sections_links', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, false, 'links', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (555, 'images', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (556, 'images', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (557, 'images', 'show_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 6, 'full', NULL, NULL, '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"season_id":{"_null":true}},{"episode_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (558, 'images', 'season_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 7, 'full', NULL, NULL, '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"episode_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (559, 'images', 'episode_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 8, 'full', NULL, NULL, '[{"name":"Show if everything is null","rule":{"_and":[{"_and":[{"show_id":{"_null":true}},{"season_id":{"_null":true}}]}]},"options":{"enableCreate":true,"enableSelect":true},"hidden":false}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (561, 'images', 'file', 'file', 'file-image', NULL, 'image', NULL, false, false, 11, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (563, 'shows', 'images', 'o2m', NULL, NULL, NULL, NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'related', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (564, 'seasons', 'images', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'related', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (565, 'episodes', 'images', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, false, 10, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (160, 'sections_links', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (161, 'sections_links', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (162, 'sections_links', 'page_id', 'pages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (163, 'sections_links', 'section_id', 'sections', 'sections_links', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (164, 'sections_links', 'icon', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (165, 'images', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (166, 'images', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (170, 'images', 'file', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (171, 'images', 'language', 'languages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (167, 'images', 'show_id', 'shows', 'images', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (168, 'images', 'season_id', 'seasons', 'images', NULL, NULL, NULL, NULL, 'delete');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (169, 'images', 'episode_id', 'episodes', 'images', NULL, NULL, NULL, NULL, 'delete');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-03T07:41:29.824Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "type" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "link_style" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "show_title" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN DROP TABLE "public"."sections_links" ---

DROP TABLE IF EXISTS "public"."sections_links";

--- END DROP TABLE "public"."sections_links" ---

--- BEGIN DROP TABLE "public"."images" ---

DROP TABLE IF EXISTS "public"."images";

--- END DROP TABLE "public"."images" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "hidden" = false WHERE "collection" = 'calendarevent';

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'sections_translations';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'sections_usergroups';

UPDATE "public"."directus_collections" SET "hidden" = false WHERE "collection" = 'tvguideentry';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'sections_links';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'images';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 142;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 123;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 208;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 245;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 247;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 274;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 403;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 236;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 237;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 246;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Featured","value":"featured"},{"text":"Default","value":"default"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"}]}' WHERE "id" = 405;

UPDATE "public"."directus_fields" SET "hidden" = false, "sort" = 4, "conditions" = NULL WHERE "id" = 535;

DELETE FROM "public"."directus_fields" WHERE "id" = 550;

DELETE FROM "public"."directus_fields" WHERE "id" = 536;

DELETE FROM "public"."directus_fields" WHERE "id" = 537;

DELETE FROM "public"."directus_fields" WHERE "id" = 552;

DELETE FROM "public"."directus_fields" WHERE "id" = 553;

DELETE FROM "public"."directus_fields" WHERE "id" = 551;

DELETE FROM "public"."directus_fields" WHERE "id" = 540;

DELETE FROM "public"."directus_fields" WHERE "id" = 541;

DELETE FROM "public"."directus_fields" WHERE "id" = 542;

DELETE FROM "public"."directus_fields" WHERE "id" = 543;

DELETE FROM "public"."directus_fields" WHERE "id" = 544;

DELETE FROM "public"."directus_fields" WHERE "id" = 560;

DELETE FROM "public"."directus_fields" WHERE "id" = 562;

DELETE FROM "public"."directus_fields" WHERE "id" = 554;

DELETE FROM "public"."directus_fields" WHERE "id" = 539;

DELETE FROM "public"."directus_fields" WHERE "id" = 545;

DELETE FROM "public"."directus_fields" WHERE "id" = 548;

DELETE FROM "public"."directus_fields" WHERE "id" = 546;

DELETE FROM "public"."directus_fields" WHERE "id" = 547;

DELETE FROM "public"."directus_fields" WHERE "id" = 538;

DELETE FROM "public"."directus_fields" WHERE "id" = 549;

DELETE FROM "public"."directus_fields" WHERE "id" = 555;

DELETE FROM "public"."directus_fields" WHERE "id" = 556;

DELETE FROM "public"."directus_fields" WHERE "id" = 557;

DELETE FROM "public"."directus_fields" WHERE "id" = 558;

DELETE FROM "public"."directus_fields" WHERE "id" = 559;

DELETE FROM "public"."directus_fields" WHERE "id" = 561;

DELETE FROM "public"."directus_fields" WHERE "id" = 563;

DELETE FROM "public"."directus_fields" WHERE "id" = 564;

DELETE FROM "public"."directus_fields" WHERE "id" = 565;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 160;

DELETE FROM "public"."directus_relations" WHERE "id" = 161;

DELETE FROM "public"."directus_relations" WHERE "id" = 162;

DELETE FROM "public"."directus_relations" WHERE "id" = 163;

DELETE FROM "public"."directus_relations" WHERE "id" = 164;

DELETE FROM "public"."directus_relations" WHERE "id" = 165;

DELETE FROM "public"."directus_relations" WHERE "id" = 166;

DELETE FROM "public"."directus_relations" WHERE "id" = 170;

DELETE FROM "public"."directus_relations" WHERE "id" = 171;

DELETE FROM "public"."directus_relations" WHERE "id" = 167;

DELETE FROM "public"."directus_relations" WHERE "id" = 168;

DELETE FROM "public"."directus_relations" WHERE "id" = 169;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
