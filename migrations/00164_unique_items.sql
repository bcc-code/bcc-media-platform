-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-02T09:17:30.467Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."collectionentries" ---

DELETE FROM users.collectionentries;

ALTER TABLE IF EXISTS "users"."collectionentries" ADD CONSTRAINT "collectionentries_unique_key" UNIQUE (collection_id, item_id);

COMMENT ON CONSTRAINT "collectionentries_unique_key" ON "users"."collectionentries" IS NULL;

CREATE UNIQUE INDEX collectionentries_unique_key_index ON users.collectionentries USING btree (collection_id, item_id);

COMMENT ON INDEX "users"."collectionentries_unique_key_index"  IS NULL;

--- END ALTER TABLE "users"."collectionentries" ---

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-05-02T09:17:31.985Z             ***/
/***********************************************************/

--- BEGIN ALTER TABLE "users"."collectionentries" ---

ALTER TABLE IF EXISTS "users"."collectionentries" DROP CONSTRAINT IF EXISTS "collectionentries_unique_key";

DROP INDEX IF EXISTS collectionentries_unique_key;

--- END ALTER TABLE "users"."collectionentries" ---

