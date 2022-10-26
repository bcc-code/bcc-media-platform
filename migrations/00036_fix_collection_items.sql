-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-26T06:17:58.050Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE FROM "public"."directus_fields" WHERE "id" = 336;

DELETE FROM "public"."directus_fields" WHERE "id" = 387;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (683, 'collections_items', 'collection_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 97;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (684, 'collections', 'collections_items', 'o2m', 'list-o2m', NULL, 'related-values', NULL, false, true, 5, 'full', NULL, NULL, '[{"name":"Shown if Select","rule":{"_and":[{"filter_type":{"_eq":"select"}}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"enableSearchFilter":false,"enableLink":false}}]', false, NULL, NULL, NULL);


--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

DELETE FROM "public"."directus_relations" WHERE "id" = 97;

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (211, 'collections_items', 'collection_id', 'collections', 'collections_items', NULL, NULL, NULL, 'sort', 'nullify');


--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-26T06:17:59.339Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 97;

DELETE FROM "public"."directus_fields" WHERE "id" = 683;

DELETE FROM "public"."directus_fields" WHERE "id" = 684;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (336, 'collections_items', 'collection_id', 'm2o', 'select-dropdown-m2o', NULL, 'related-values', NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (387, 'collections', 'items', 'o2m', 'list-o2m', '{"enableSelect":false}', NULL, NULL, false, false, 8, 'full', NULL, NULL, '[{"name":"Hidden if not Select","rule":{"_and":[{"filter_type":{"_neq":"select"}}]},"hidden":true,"options":{"enableCreate":true,"enableSelect":true,"limit":15}}]', false, 'config', NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
DELETE FROM "public"."directus_relations" WHERE "id" = 211;

INSERT INTO "public"."directus_relations" ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field", "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")  VALUES (97, 'collections_items', 'collection_id', 'collections', 'items', NULL, NULL, NULL, 'sort', 'nullify');

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
