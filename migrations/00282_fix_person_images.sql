-- +goose Up

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3033, 'persons', 'images', 'm2m', 'list-m2m', NULL, NULL, NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 3026;

UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 3027;

DELETE FROM "public"."directus_fields" WHERE "id" = 3028;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1404;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 1422;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1406;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1400;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1403;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 483;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 481;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 484;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1414;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1401;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1402;

UPDATE "public"."directus_fields" SET "sort" = 15 WHERE "id" = 1435;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1442;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1477;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1472;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1431;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 486;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 485;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1481;

UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1441;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1460;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1466;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1458;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1465;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1488;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1467;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1471;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1405;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 1427;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 495;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1517;

DELETE FROM "public"."directus_fields" WHERE "id" = 1523;

-- +goose Down


UPDATE "public"."directus_fields" SET "sort" = 12 WHERE "id" = 1422;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1427;

UPDATE "public"."directus_fields" SET "sort" = 13 WHERE "id" = 1435;

UPDATE "public"."directus_fields" SET "sort" = 6 WHERE "id" = 1431;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1404;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1400;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1406;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1402;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1405;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1414;

UPDATE "public"."directus_fields" SET "sort" = 10 WHERE "id" = 1441;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1401;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 481;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 484;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 485;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1458;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1403;

UPDATE "public"."directus_fields" SET "sort" = 8 WHERE "id" = 483;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 486;

UPDATE "public"."directus_fields" SET "sort" = 11 WHERE "id" = 1466;

UPDATE "public"."directus_fields" SET "sort" = 1 WHERE "id" = 1471;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 495;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1467;

UPDATE "public"."directus_fields" SET "sort" = 2 WHERE "id" = 1472;

UPDATE "public"."directus_fields" SET "sort" = 5 WHERE "id" = 1477;

UPDATE "public"."directus_fields" SET "sort" = 4 WHERE "id" = 1481;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1442;

UPDATE "public"."directus_fields" SET "sort" = 14 WHERE "id" = 1488;

UPDATE "public"."directus_fields" SET "sort" = 9 WHERE "id" = 1460;

UPDATE "public"."directus_fields" SET "sort" = 3 WHERE "id" = 1465;

UPDATE "public"."directus_fields" SET "sort" = 7 WHERE "id" = 1517;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (1523, 'mediaitems', '_assets', 'alias,no-data,group', 'group-detail', '{"headerIcon":"file_present"}', NULL, NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 3026;

UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 3027;

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display", "display_options", "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required", "group", "validation", "validation_message")  VALUES (3028, 'persons', 'images', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 3, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL);

DELETE FROM "public"."directus_fields" WHERE "id" = 3033;

