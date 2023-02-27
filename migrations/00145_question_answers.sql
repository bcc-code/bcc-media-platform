-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-27T10:48:28.331Z             ***/
/***********************************************************/

--- BEGIN CREATE TABLE "users"."surveyquestionanswers" ---

CREATE TABLE IF NOT EXISTS "users"."surveyquestionanswers" (
	"id" varchar(64) NOT NULL  ,
	"question_id" uuid NOT NULL  ,
	"answer" text NULL  ,
	"updated_at" timestamp NOT NULL  ,
	CONSTRAINT "surveyquestionanswers_pk" PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS surveyquestionanswers_id_uindex ON users.surveyquestionanswers USING btree (id);

GRANT SELECT ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."surveyquestionanswers" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."surveyquestionanswers"."id"  IS NULL;


COMMENT ON COLUMN "users"."surveyquestionanswers"."question_id"  IS NULL;


COMMENT ON COLUMN "users"."surveyquestionanswers"."answer"  IS NULL;


COMMENT ON COLUMN "users"."surveyquestionanswers"."updated_at"  IS NULL;

COMMENT ON CONSTRAINT "surveyquestionanswers_pk" ON "users"."surveyquestionanswers" IS NULL;

COMMENT ON INDEX "users"."surveyquestionanswers_id_uindex"  IS NULL;

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
