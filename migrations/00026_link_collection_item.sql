-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-14T09:59:14.117Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."links_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."links_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

COMMENT ON SEQUENCE "public"."links_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."links_id_seq" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP COLUMN IF EXISTS "link_style" CASCADE; --WARN: Drop column can occure in data loss!

--- END ALTER TABLE "public"."sections" ---

--- BEGIN CREATE TABLE "public"."links" ---

CREATE TABLE IF NOT EXISTS "public"."links" (
	"id" int4 NOT NULL DEFAULT nextval('links_id_seq'::regclass) ,
	"status" varchar(255) NOT NULL DEFAULT 'draft'::character varying ,
	"user_created" uuid NULL  ,
	"date_created" timestamptz NULL  ,
	"user_updated" uuid NULL  ,
	"date_updated" timestamptz NULL  ,
	"url" varchar(255) NOT NULL  ,
	CONSTRAINT "links_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "links_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "links_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id)
);

GRANT SELECT ON TABLE "public"."links" TO directus, api, background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."links"."id"  IS NULL;


COMMENT ON COLUMN "public"."links"."status"  IS NULL;


COMMENT ON COLUMN "public"."links"."user_created"  IS NULL;


COMMENT ON COLUMN "public"."links"."date_created"  IS NULL;


COMMENT ON COLUMN "public"."links"."user_updated"  IS NULL;


COMMENT ON COLUMN "public"."links"."date_updated"  IS NULL;


COMMENT ON COLUMN "public"."links"."url"  IS NULL;

COMMENT ON CONSTRAINT "links_pkey" ON "public"."links" IS NULL;


COMMENT ON CONSTRAINT "links_user_created_foreign" ON "public"."links" IS NULL;


COMMENT ON CONSTRAINT "links_user_updated_foreign" ON "public"."links" IS NULL;

COMMENT ON TABLE "public"."links"  IS NULL;

--- END CREATE TABLE "public"."links" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" ADD COLUMN IF NOT EXISTS "link_id" int4 NULL  ;

COMMENT ON COLUMN "public"."images"."link_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."images" ADD CONSTRAINT "images_link_id_foreign" FOREIGN KEY (link_id) REFERENCES links(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "images_link_id_foreign" ON "public"."images" IS NULL;

--- END ALTER TABLE "public"."images" ---

--- BEGIN ALTER TABLE "public"."collections_items" ---

ALTER TABLE IF EXISTS "public"."collections_items" ADD COLUMN IF NOT EXISTS "link_id" int4 NULL  ;

COMMENT ON COLUMN "public"."collections_items"."link_id"  IS NULL;

ALTER TABLE IF EXISTS "public"."collections_items" ADD CONSTRAINT "collections_items_link_id_foreign" FOREIGN KEY (link_id) REFERENCES links(id) ON DELETE SET NULL;

COMMENT ON CONSTRAINT "collections_items_link_id_foreign" ON "public"."collections_items" IS NULL;

--- END ALTER TABLE "public"."collections_items" ---

--- BEGIN DROP TABLE "public"."sections_links" ---

DROP TABLE IF EXISTS "public"."sections_links";

--- END DROP TABLE "public"."sections_links" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 7 WHERE "collection" = 'categories';

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'tags';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'lists';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('links', 'http', NULL, NULL, false, false, NULL, 'status', true, 'archived', 'draft', NULL, 'all', NULL, NULL, 4, 'page_management', 'open');

DELETE FROM "public"."directus_collections" WHERE "collection" = 'sections_links';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (636, 'links', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (637, 'links', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (638, 'links', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (639, 'links', 'url', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (641, 'images', 'link_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 10, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 561;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (643, 'collections_items', 'link_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, true, 6, 'half', NULL, NULL, '[{"name":"Type is link","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{"enableCreate":true,"enableSelect":true}}]', false, 'config', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (642, 'links', 'images', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Page","value":"page"},{"text":"Show","value":"show"},{"text":"Episode","value":"episode"},{"text":"Link","value":"link"}]}' WHERE "id" = 346;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (633, 'links', 'id', NULL, 'input', NULL, NULL, NULL, true, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 560;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 562;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 536;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (634, 'links', 'status', NULL, 'select-dropdown', '{"choices":[{"text":"$t:published","value":"published"},{"text":"$t:draft","value":"draft"},{"text":"$t:archived","value":"archived"}]}', 'labels', '{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","foreground":"#FFFFFF","background":"var(--primary)"},{"text":"$t:draft","value":"draft","foreground":"#18222F","background":"#D3DAE4"},{"text":"$t:archived","value":"archived","foreground":"#FFFFFF","background":"var(--warning)"}]}', false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (635, 'links', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, NULL, 'half', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 550;

DELETE FROM "public"."directus_fields" WHERE "id" = 537;

DELETE FROM "public"."directus_fields" WHERE "id" = 540;

DELETE FROM "public"."directus_fields" WHERE "id" = 541;

DELETE FROM "public"."directus_fields" WHERE "id" = 542;

DELETE FROM "public"."directus_fields" WHERE "id" = 543;

DELETE FROM "public"."directus_fields" WHERE "id" = 544;

DELETE FROM "public"."directus_fields" WHERE "id" = 539;

DELETE FROM "public"."directus_fields" WHERE "id" = 545;

DELETE FROM "public"."directus_fields" WHERE "id" = 548;

DELETE FROM "public"."directus_fields" WHERE "id" = 546;

DELETE FROM "public"."directus_fields" WHERE "id" = 547;

DELETE FROM "public"."directus_fields" WHERE "id" = 538;

DELETE FROM "public"."directus_fields" WHERE "id" = 549;

DELETE FROM "public"."directus_fields" WHERE "id" = 609;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (194, 'links', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (195, 'links', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (197, 'images', 'link_id', 'links', 'images', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (198, 'collections_items', 'link_id', 'links', NULL, NULL, NULL, NULL, NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 160;

DELETE FROM "public"."directus_relations" WHERE "id" = 161;

DELETE FROM "public"."directus_relations" WHERE "id" = 162;

DELETE FROM "public"."directus_relations" WHERE "id" = 163;

DELETE FROM "public"."directus_relations" WHERE "id" = 164;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-14T09:59:15.312Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."collections_items" ---

ALTER TABLE IF EXISTS "public"."collections_items" DROP COLUMN IF EXISTS "link_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."collections_items" DROP CONSTRAINT IF EXISTS "collections_items_link_id_foreign";

--- END ALTER TABLE "public"."collections_items" ---

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
	"title" varchar(255) NOT NULL  ,
	CONSTRAINT "sections_links_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "sections_links_user_created_foreign" FOREIGN KEY (user_created) REFERENCES directus_users(id) ,
	CONSTRAINT "sections_links_user_updated_foreign" FOREIGN KEY (user_updated) REFERENCES directus_users(id) ,
	CONSTRAINT "sections_links_page_id_foreign" FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE SET NULL ,
	CONSTRAINT "sections_links_section_id_foreign" FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE ,
	CONSTRAINT "sections_links_icon_foreign" FOREIGN KEY (icon) REFERENCES directus_files(id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."sections_links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."sections_links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."sections_links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."sections_links" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

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


COMMENT ON COLUMN "public"."sections_links"."title"  IS NULL;

COMMENT ON CONSTRAINT "sections_links_pkey" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_user_created_foreign" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_user_updated_foreign" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_page_id_foreign" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_section_id_foreign" ON "public"."sections_links" IS NULL;


COMMENT ON CONSTRAINT "sections_links_icon_foreign" ON "public"."sections_links" IS NULL;

COMMENT ON TABLE "public"."sections_links"  IS NULL;

--- END CREATE TABLE "public"."sections_links" ---

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" ADD COLUMN IF NOT EXISTS "link_style" varchar(255) NULL  ;

COMMENT ON COLUMN "public"."sections"."link_style"  IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN ALTER TABLE "public"."images" ---

ALTER TABLE IF EXISTS "public"."images" DROP COLUMN IF EXISTS "link_id" CASCADE; --WARN: Drop column can occure in data loss!

ALTER TABLE IF EXISTS "public"."images" DROP CONSTRAINT IF EXISTS "images_link_id_foreign";

--- END ALTER TABLE "public"."images" ---

--- BEGIN DROP TABLE "public"."links" ---

DROP TABLE IF EXISTS "public"."links";

--- END DROP TABLE "public"."links" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 6 WHERE "collection" = 'categories';

UPDATE "public"."directus_collections" SET "sort" = 5 WHERE "collection" = 'tags';

UPDATE "public"."directus_collections" SET "sort" = 4 WHERE "collection" = 'lists';

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sections_links', NULL, NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, 'sort', 'all', NULL, NULL, 1, 'sections', 'open');

DELETE FROM "public"."directus_collections" WHERE "collection" = 'links';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (550, 'sections_links', 'icon', 'file', 'file-image', NULL, 'image', NULL, false, false, NULL, 'full', NULL, 'Should be set if Section->Link Style is icons', NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 536;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (537, 'sections', 'links', 'alias,no-data,group', 'group-detail', NULL, NULL, NULL, false, true, 4, 'full', NULL, NULL, '[{"name":"Shown if LinkSection","rule":{"_and":[{"type":{"_eq":"link"}}]},"hidden":false,"options":{}}]', false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (540, 'sections_links', 'sort', NULL, 'input', NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (541, 'sections_links', 'user_created', 'user-created', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 2, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (542, 'sections_links', 'date_created', 'date-created', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 3, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (543, 'sections_links', 'user_updated', 'user-updated', 'select-dropdown-m2o', '{"template":"{{avatar.$thumbnail}} {{first_name}} {{last_name}}"}', 'user', NULL, true, true, 4, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (544, 'sections_links', 'date_updated', 'date-updated', 'datetime', NULL, 'datetime', '{"relative":true}', true, true, 5, 'half', NULL, NULL, NULL, false, 'metadata', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (539, 'sections_links', 'id', NULL, 'input', NULL, NULL, NULL, true, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (545, 'sections_links', 'metadata', 'alias,no-data,group', NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (548, 'sections_links', 'section_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (546, 'sections_links', 'page_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 4, 'full', NULL, 'Either this or URL must be specified', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (547, 'sections_links', 'url', NULL, 'input', NULL, NULL, NULL, false, false, 5, 'full', NULL, 'Required if Page is not set', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (538, 'sections', 'link_style', NULL, 'select-dropdown', '{"choices":[{"text":"Icons","value":"icons"},{"text":"Labels","value":"labels"}]}', 'labels', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'links', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (549, 'sections', 'sections_links', 'o2m', 'list-o2m', NULL, NULL, NULL, false, false, 2, 'full', NULL, NULL, NULL, false, 'links', NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (609, 'sections_links', 'title', NULL, 'input', NULL, 'raw', NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Page","value":"page"},{"text":"Show","value":"show"},{"text":"Episode","value":"episode"}]}' WHERE "id" = 346;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 561;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 560;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 562;

DELETE FROM "public"."directus_fields" WHERE "id" = 636;

DELETE FROM "public"."directus_fields" WHERE "id" = 637;

DELETE FROM "public"."directus_fields" WHERE "id" = 638;

DELETE FROM "public"."directus_fields" WHERE "id" = 639;

DELETE FROM "public"."directus_fields" WHERE "id" = 641;

DELETE FROM "public"."directus_fields" WHERE "id" = 643;

DELETE FROM "public"."directus_fields" WHERE "id" = 642;

DELETE FROM "public"."directus_fields" WHERE "id" = 633;

DELETE FROM "public"."directus_fields" WHERE "id" = 634;

DELETE FROM "public"."directus_fields" WHERE "id" = 635;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (160, 'sections_links', 'user_created', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (161, 'sections_links', 'user_updated', 'directus_users', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (162, 'sections_links', 'page_id', 'pages', NULL, NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (163, 'sections_links', 'section_id', 'sections', 'sections_links', NULL, NULL, NULL, NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (164, 'sections_links', 'icon', 'directus_files', NULL, NULL, NULL, NULL, NULL, 'nullify');

DELETE FROM "public"."directus_relations" WHERE "id" = 194;

DELETE FROM "public"."directus_relations" WHERE "id" = 195;

DELETE FROM "public"."directus_relations" WHERE "id" = 197;

DELETE FROM "public"."directus_relations" WHERE "id" = 198;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
