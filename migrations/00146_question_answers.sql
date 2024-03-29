-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-27T10:48:28.331Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."surveyquestionanswers" ---

CREATE TABLE IF NOT EXISTS "users"."surveyquestionanswers" (
	"profile_id" uuid NOT NULL  ,
	"question_id" uuid NOT NULL  ,
	"updated_at" timestamp NOT NULL  ,
	CONSTRAINT "surveyquestionanswers_pk" PRIMARY KEY (profile_id, question_id)
);

GRANT SELECT ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."surveyquestionanswers"."profile_id"  IS NULL;


COMMENT ON COLUMN "users"."surveyquestionanswers"."question_id"  IS NULL;


COMMENT ON COLUMN "users"."surveyquestionanswers"."updated_at"  IS NULL;

COMMENT ON CONSTRAINT "surveyquestionanswers_pk" ON "users"."surveyquestionanswers" IS NULL;

COMMENT ON TABLE "users"."surveyquestionanswers"  IS NULL;

--- END CREATE TABLE "users"."surveyquestionanswers" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-27T10:48:29.849Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "users"."surveyquestionanswers" ---

DROP TABLE IF EXISTS "users"."surveyquestionanswers";

--- END DROP TABLE "users"."surveyquestionanswers" ---
