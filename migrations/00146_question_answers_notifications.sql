-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-27T13:21:20.414Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."targets" ---

GRANT SELECT ON TABLE "public"."targets" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."targets" ---

--- BEGIN ALTER TABLE "public"."targets_usergroups" ---

GRANT SELECT ON TABLE "public"."targets_usergroups" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."targets_usergroups" ---

--- BEGIN ALTER TABLE "users"."surveyquestionanswers" ---

ALTER TABLE IF EXISTS "users"."surveyquestionanswers" ADD CONSTRAINT "surveyquestionanswers_surveyquestions_id_fk" FOREIGN KEY (question_id) REFERENCES surveyquestions(id) ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON CONSTRAINT "surveyquestionanswers_surveyquestions_id_fk" ON "users"."surveyquestionanswers" IS NULL;

--- END ALTER TABLE "users"."surveyquestionanswers" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "item_duplication_fields" = '["template_id","schedule_at","action","deep_link","targets.targets_id"]' WHERE "collection" = 'notifications';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-27T13:21:21.992Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "public"."targets" ---

REVOKE SELECT ON TABLE "public"."targets" FROM api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."targets" ---

--- BEGIN ALTER TABLE "public"."targets_usergroups" ---

REVOKE SELECT ON TABLE "public"."targets_usergroups" FROM api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

--- END ALTER TABLE "public"."targets_usergroups" ---

--- BEGIN ALTER TABLE "users"."surveyquestionanswers" ---

ALTER TABLE IF EXISTS "users"."surveyquestionanswers" DROP CONSTRAINT IF EXISTS "surveyquestionanswers_surveyquestions_id_fk";

--- END ALTER TABLE "users"."surveyquestionanswers" ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---

UPDATE "public"."directus_collections" SET "item_duplication_fields" = NULL WHERE "collection" = 'notifications';

--- END SYNCHRONIZE TABLE "public"."directus_collections" RECORDS ---
