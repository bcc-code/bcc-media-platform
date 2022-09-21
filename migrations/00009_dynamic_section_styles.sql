-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-21T07:06:26.480Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "public"."sectionstyles" ---

CREATE TABLE IF NOT EXISTS "public"."sectionstyles" (
	"code" varchar(255) NOT NULL  ,
	CONSTRAINT "sectionstyles_pkey" PRIMARY KEY (code)
);

ALTER TABLE IF EXISTS "public"."sectionstyles" OWNER TO btv;

GRANT SELECT ON TABLE "public"."sectionstyles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."sectionstyles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."sectionstyles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."sectionstyles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."sectionstyles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."sectionstyles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."sectionstyles" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."sectionstyles"."code"  IS NULL;

COMMENT ON CONSTRAINT "sectionstyles_pkey" ON "public"."sectionstyles" IS NULL;

COMMENT ON TABLE "public"."sectionstyles"  IS NULL;

--- END CREATE TABLE "public"."sectionstyles" ---

--- BEGIN SYNCHRONIZE TABLE

INSERT INTO "public"."sectionstyles" (code) VALUES ('featured'), ('slider'), ('cards');

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections"
	ALTER COLUMN "style" DROP DEFAULT ;

ALTER TABLE IF EXISTS "public"."sections" ADD CONSTRAINT "sections_style_foreign" FOREIGN KEY (style) REFERENCES sectionstyles(code);

COMMENT ON CONSTRAINT "sections_style_foreign" ON "public"."sections" IS NULL;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

INSERT INTO "public"."directus_collections" ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations", "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field", "accountability", "color", "item_duplication_fields", "sort", "group", "collapse")  VALUES ('sectionstyles', NULL, NULL, NULL, false, false, NULL, NULL, true, NULL, NULL, NULL, 'all', NULL, '[]', 1, 'sections', 'open');

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'sections_translations';

UPDATE "public"."directus_collections" SET "sort" = 3 WHERE "collection" = 'sections_usergroups';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (491, 'sectionstyles', 'code', NULL, 'input', NULL, NULL, NULL, false, false, NULL, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (502, 'sections', 'style', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 1, 'full', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 403;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 245;

DELETE FROM "public"."directus_fields" WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (145, 'sections', 'style', 'sectionstyles', NULL, NULL, NULL, NULL, NULL, 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-09-21T07:06:27.574Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."sections" ---

ALTER TABLE IF EXISTS "public"."sections" DROP CONSTRAINT IF EXISTS "sections_style_foreign";

ALTER TABLE IF EXISTS "public"."sections"
	ALTER COLUMN "style" SET DEFAULT NULL::character varying;

--- END ALTER TABLE "public"."sections" ---

--- BEGIN DROP TABLE "public"."sectionstyles" ---

DROP TABLE IF EXISTS "public"."sectionstyles";

--- END DROP TABLE "public"."sectionstyles" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "sort" = 1 WHERE "collection" = 'sections_translations';

UPDATE "public"."directus_collections" SET "sort" = 2 WHERE "collection" = 'sections_usergroups';

DELETE FROM "public"."directus_collections" WHERE "collection" = 'sectionstyles';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 245;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 403;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (405, 'sections', 'style', NULL, 'select-dropdown', '{"choices":[{"text":"Slider","value":"carousel"},{"text":"Cards","value":"cards"}]}', 'raw', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, 'configuration', NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 491;

DELETE FROM "public"."directus_fields" WHERE "id" = 502;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 145;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
