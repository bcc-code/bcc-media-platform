-- +goose Up

--- BEGIN ALTER TABLE "public"."calendarentries" ADD "buffer_available_hours" ---

ALTER TABLE "public"."calendarentries" ADD COLUMN IF NOT EXISTS "buffer_available_hours" int4 NULL DEFAULT 48;

COMMENT ON COLUMN "public"."calendarentries"."buffer_available_hours" IS 'Hours the buffer URL stays available after the entry ends. 0 = never available.';

--- END ALTER TABLE "public"."calendarentries" ADD "buffer_available_hours" ---

--- BEGIN CREATE SEQUENCE "public"."calendarentries_usergroups_buffer_id_seq" ---

CREATE SEQUENCE IF NOT EXISTS "public"."calendarentries_usergroups_buffer_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."calendarentries_usergroups_buffer_id_seq" TO directus, onsite_backup;
GRANT USAGE ON SEQUENCE "public"."calendarentries_usergroups_buffer_id_seq" TO directus;
GRANT UPDATE ON SEQUENCE "public"."calendarentries_usergroups_buffer_id_seq" TO directus;

--- END CREATE SEQUENCE "public"."calendarentries_usergroups_buffer_id_seq" ---

--- BEGIN CREATE TABLE "public"."calendarentries_usergroups_buffer" ---

CREATE TABLE IF NOT EXISTS "public"."calendarentries_usergroups_buffer" (
	"id" int4 NOT NULL DEFAULT nextval('calendarentries_usergroups_buffer_id_seq'::regclass) ,
	"calendarentries_id" int4 NULL  ,
	"usergroups_code" varchar(255) NULL  ,
	CONSTRAINT "calendarentries_usergroups_buffer_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "calendarentries_usergroups_buffer_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE SET NULL ,
	CONSTRAINT "calendarentries_usergroups_buffer_calendarentries_id_foreign" FOREIGN KEY (calendarentries_id) REFERENCES calendarentries(id) ON DELETE SET NULL
);

GRANT SELECT ON TABLE "public"."calendarentries_usergroups_buffer" TO directus, api, onsite_backup;
GRANT INSERT ON TABLE "public"."calendarentries_usergroups_buffer" TO directus;
GRANT UPDATE ON TABLE "public"."calendarentries_usergroups_buffer" TO directus;
GRANT DELETE ON TABLE "public"."calendarentries_usergroups_buffer" TO directus;
GRANT TRUNCATE ON TABLE "public"."calendarentries_usergroups_buffer" TO directus;
GRANT REFERENCES ON TABLE "public"."calendarentries_usergroups_buffer" TO directus;
GRANT TRIGGER ON TABLE "public"."calendarentries_usergroups_buffer" TO directus;

--- END CREATE TABLE "public"."calendarentries_usergroups_buffer" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3101, 'calendarentries', 'buffer_available_hours', NULL, 'input', NULL, NULL, NULL, false, false, 20, 'full', NULL, 'Hours the buffer URL stays available after the entry ends. 0 = never available. Defaults to 48 if unset. Capped at 168 (7 days).', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3102, 'calendarentries', 'buffer_usergroups', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 21, 'full', NULL, 'If empty, the buffer URL is available to all BCC members, else only those specified.', NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3103, 'calendarentries_usergroups_buffer', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3104, 'calendarentries_usergroups_buffer', 'calendarentries_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3105, 'calendarentries_usergroups_buffer', 'usergroups_code', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse", "preview_url", "versioning")  VALUES ('calendarentries_usergroups_buffer', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (494, 'calendarentries_usergroups_buffer', 'usergroups_code', 'usergroups', NULL, NULL, NULL, 'calendarentries_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (495, 'calendarentries_usergroups_buffer', 'calendarentries_id', 'calendarentries', 'buffer_usergroups', NULL, NULL, 'usergroups_code', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 494;

DELETE FROM "public"."directus_relations" WHERE "id" = 495;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 3101;

DELETE FROM "public"."directus_fields" WHERE "id" = 3102;

DELETE FROM "public"."directus_fields" WHERE "id" = 3103;

DELETE FROM "public"."directus_fields" WHERE "id" = 3104;

DELETE FROM "public"."directus_fields" WHERE "id" = 3105;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'calendarentries_usergroups_buffer';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN DROP TABLE "public"."calendarentries_usergroups_buffer" ---

DROP TABLE IF EXISTS "public"."calendarentries_usergroups_buffer";

--- END DROP TABLE "public"."calendarentries_usergroups_buffer" ---

--- BEGIN ALTER TABLE "public"."calendarentries" DROP "buffer_available_hours" ---

ALTER TABLE "public"."calendarentries" DROP COLUMN IF EXISTS "buffer_available_hours";

--- END ALTER TABLE "public"."calendarentries" DROP "buffer_available_hours" ---
