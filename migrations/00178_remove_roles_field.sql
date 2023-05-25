-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:09:39.654Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

DELETE
FROM "public"."directus_fields"
WHERE "id" = 510;

INSERT INTO "public"."applicationgroups_usergroups" (applicationgroups_id, usergroups_code) (SELECT DISTINCT ON (a.group_id, ug.usergroups_code) a.group_id,
                                                                                                                                                 ug.usergroups_code
                                                                                             FROM "applications_usergroups" ug
                                                                                                      JOIN applications a on a.id = ug.applications_id);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-25T12:09:41.371Z             ***/
/***********************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

INSERT INTO "public"."directus_fields" ("id", "collection", "field", "special", "interface", "options", "display",
                                        "display_options", "readonly", "hidden", "sort", "width", "translations",
                                        "note", "conditions", "required", "group", "validation", "validation_message")
VALUES (510, 'applications', 'roles', 'm2m', 'list-m2m', NULL, 'related-values', NULL, false, false, 11, 'full', NULL,
        NULL, NULL, false, NULL, NULL, NULL);

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
