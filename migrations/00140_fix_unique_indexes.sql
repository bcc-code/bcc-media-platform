-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-20T13:18:10.933Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."devices" ---

CREATE INDEX devices_updated_at_index ON users.devices USING btree (updated_at);

COMMENT ON INDEX "users"."devices_updated_at_index"  IS NULL;

DROP INDEX IF EXISTS "users"."devices_token_uindex";

DROP INDEX IF EXISTS "users"."devices_updated_at_uindex";

--- END ALTER TABLE "users"."devices" ---
-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-02-20T13:18:12.570Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."devices" ---

CREATE UNIQUE INDEX devices_token_uindex ON users.devices USING btree (token);

COMMENT ON INDEX "users"."devices_token_uindex"  IS NULL;

CREATE UNIQUE INDEX devices_updated_at_uindex ON users.devices USING btree (updated_at);

COMMENT ON INDEX "users"."devices_updated_at_uindex"  IS NULL;

DROP INDEX IF EXISTS "users"."devices_updated_at_index";

--- END ALTER TABLE "users"."devices" ---
