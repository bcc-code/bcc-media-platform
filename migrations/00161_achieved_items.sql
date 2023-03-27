-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-24T10:34:47.688Z             ***/
/***********************************************************/

--- BEGIN CREATE SEQUENCE "public"."achievementconditions_studytopics_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."achievementconditions_studytopics_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

GRANT SELECT ON SEQUENCE "public"."achievementconditions_studytopics_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."achievementconditions_studytopics_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."achievementconditions_studytopics_id_seq" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."achievementconditions_studytopics_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."achievementconditions_studytopics_id_seq" ---

--- BEGIN CREATE TABLE "public"."achievementconditions_studytopics" ---

CREATE TABLE IF NOT EXISTS "public"."achievementconditions_studytopics" (
	"id" int4 NOT NULL DEFAULT nextval('achievementconditions_studytopics_id_seq'::regclass) ,
	"achievementconditions_id" uuid NULL  ,
	"studytopics_id" uuid NULL  ,
	CONSTRAINT "achievementconditions_studytopics_pkey" PRIMARY KEY (id) ,
	CONSTRAINT "achievementconditions_studytopics_studytopics_id_foreign" FOREIGN KEY (studytopics_id) REFERENCES studytopics(id) ON DELETE CASCADE ,
	CONSTRAINT "achievementconditions_studytopics_achievem__2e3395b2_foreign" FOREIGN KEY (achievementconditions_id) REFERENCES achievementconditions(id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."achievementconditions_studytopics" TO directus, api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."achievementconditions_studytopics" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."achievementconditions_studytopics" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."achievementconditions_studytopics" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."achievementconditions_studytopics" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."achievementconditions_studytopics" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."achievementconditions_studytopics" TO directus; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."achievementconditions_studytopics"."id"  IS NULL;


COMMENT ON COLUMN "public"."achievementconditions_studytopics"."achievementconditions_id"  IS NULL;


COMMENT ON COLUMN "public"."achievementconditions_studytopics"."studytopics_id"  IS NULL;

COMMENT ON CONSTRAINT "achievementconditions_studytopics_pkey" ON "public"."achievementconditions_studytopics" IS NULL;


COMMENT ON CONSTRAINT "achievementconditions_studytopics_studytopics_id_foreign" ON "public"."achievementconditions_studytopics" IS NULL;


COMMENT ON CONSTRAINT "achievementconditions_studytopics_achievem__2e3395b2_foreign" ON "public"."achievementconditions_studytopics" IS NULL;

COMMENT ON TABLE "public"."achievementconditions_studytopics"  IS NULL;

--- END CREATE TABLE "public"."achievementconditions_studytopics" ---

--- BEGIN ALTER TABLE "public"."achievementconditions" ---

ALTER TABLE IF EXISTS "public"."achievementconditions"
	ALTER COLUMN "amount" DROP NOT NULL;

--- END ALTER TABLE "public"."achievementconditions" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('achievementconditions_studytopics', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open');

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Watched","rule":{"_and":[{"_and":[{"collection":{"_eq":"episodes"}}]}]},"options":{"allowOther":false,"allowNone":false,"choices":[{"text":"Watched","value":"watched"}]}},{"name":"Completed","rule":{"_and":[{"collection":{"_in":["lessons","tasks","topics"]}}]},"options":{"allowOther":false,"allowNone":false,"choices":[{"text":"Completed","value":"completed"},{"text":"Completed Items","value":"completed_items"}]}}]' WHERE "id" = 942;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1128, 'achievementconditions_studytopics', 'id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1129, 'achievementconditions_studytopics', 'achievementconditions_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1130, 'achievementconditions_studytopics', 'studytopics_id', NULL, NULL, NULL, NULL, NULL, false, true, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"hide if completed items","rule":{"_and":[{"action":{"_eq":"completed_items"}}]},"hidden":true,"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false}}]' WHERE "id" = 943;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1127, 'achievementconditions', 'topics', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, true, NULL, 'full', NULL, NULL, '[{"name":"show if topic and action is completed items","rule":{"_and":[{"_and":[{"collection":{"_eq":"topics"}},{"action":{"_eq":"completed_items"}}]}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"junctionFieldLocation":"bottom","allowDuplicates":false,"enableSearchFilter":false,"enableLink":false}}]', false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (344, 'achievementconditions_studytopics', 'studytopics_id', 'studytopics', NULL, NULL, NULL, 'achievementconditions_id', NULL, 'nullify');

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (345, 'achievementconditions_studytopics', 'achievementconditions_id', 'achievementconditions', 'topics', NULL, NULL, 'studytopics_id', NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-24T10:34:49.284Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."achievementconditions" ---

UPDATE "public"."achievementconditions" SET amount = 0 WHERE amount IS NULL;


ALTER TABLE IF EXISTS "public"."achievementconditions"
	ALTER COLUMN "amount" SET NOT NULL;

--- END ALTER TABLE "public"."achievementconditions" ---

--- BEGIN DROP TABLE "public"."achievementconditions_studytopics" ---

DROP TABLE IF EXISTS "public"."achievementconditions_studytopics";

--- END DROP TABLE "public"."achievementconditions_studytopics" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

DELETE FROM "public"."directus_collections" WHERE "collection" = 'achievementconditions_studytopics';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "conditions" = NULL WHERE "id" = 943;

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"Watched","rule":{"_and":[{"_and":[{"collection":{"_eq":"episodes"}}]}]},"options":{"allowOther":false,"allowNone":false,"choices":[{"text":"Watched","value":"watched"}]}},{"name":"Completed","rule":{"_and":[{"collection":{"_in":["lessons","tasks","topics"]}}]},"options":{"allowOther":false,"allowNone":false,"choices":[{"text":"Completed","value":"completed"}]}}]' WHERE "id" = 942;

DELETE FROM "public"."directus_fields" WHERE "id" = 1128;

DELETE FROM "public"."directus_fields" WHERE "id" = 1129;

DELETE FROM "public"."directus_fields" WHERE "id" = 1130;

DELETE FROM "public"."directus_fields" WHERE "id" = 1127;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 344;

DELETE FROM "public"."directus_relations" WHERE "id" = 345;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
