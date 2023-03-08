-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-03T08:24:36.444Z             ***/
/***********************************************************/

--- ADD UUID TO applications
ALTER TABLE public.applications
    ADD COLUMN uuid uuid NULL;

UPDATE public.applications
SET uuid = gen_random_uuid();

alter table public.applications
    alter column uuid set not null;

alter table applications
    add constraint applications_uuid_unique
        unique (uuid);

--- END add uuid to applications

--- BEGIN CREATE TABLE "users"."collections" ---

CREATE TABLE IF NOT EXISTS "users"."collections"
(
    "id"             uuid      NOT NULL,
    "application_id" uuid      NOT NULL,
    "profile_id"     uuid      NOT NULL,
    "updated_at"     timestamp NOT NULL,
    "created_at"     timestamp NOT NULL,
    "my_list"        bool      NOT NULL,
    "title"          text      NOT NULL,
    CONSTRAINT "collections_pk" PRIMARY KEY (id),
    CONSTRAINT "collections_applications_id_fk" FOREIGN KEY (application_id) REFERENCES public.applications (uuid) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "collections_profiles_id_fk" FOREIGN KEY (profile_id) REFERENCES users.profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
);

GRANT SELECT ON TABLE "users"."collections" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."collections" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."collections" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."collections" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."collections" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."collections" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."collections" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."collections"."id" IS NULL;


COMMENT ON COLUMN "users"."collections"."application_id" IS NULL;


COMMENT ON COLUMN "users"."collections"."profile_id" IS NULL;


COMMENT ON COLUMN "users"."collections"."updated_at" IS NULL;


COMMENT ON COLUMN "users"."collections"."created_at" IS NULL;


COMMENT ON COLUMN "users"."collections"."title" IS NULL;

COMMENT ON CONSTRAINT "collections_pk" ON "users"."collections" IS NULL;


COMMENT ON CONSTRAINT "collections_profiles_id_fk" ON "users"."collections" IS NULL;

COMMENT ON TABLE "users"."collections" IS NULL;

--- END CREATE TABLE "users"."collections" ---

--- BEGIN CREATE TABLE "users"."collectionentries" ---

CREATE TABLE IF NOT EXISTS "users"."collectionentries"
(
    "id"            uuid         NOT NULL,
    "collection_id" uuid         NOT NULL,
    "sort"          int4         NOT NULL,
    "type"          varchar(255) NOT NULL,
    "item_id"       uuid         NOT NULL,
    "created_at"    timestamp    NOT NULL,
    "updated_at"    timestamp    NOT NULL,
    CONSTRAINT "collectionentries_pk" PRIMARY KEY (id),
    CONSTRAINT "collectionentries_collections_id_fk" FOREIGN KEY (collection_id) REFERENCES users.collections (id)
);

GRANT SELECT ON TABLE "users"."collectionentries" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "users"."collectionentries" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "users"."collectionentries" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "users"."collectionentries" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "users"."collectionentries" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "users"."collectionentries" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "users"."collectionentries" TO api; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "users"."collectionentries"."id" IS NULL;


COMMENT ON COLUMN "users"."collectionentries"."collection_id" IS NULL;


COMMENT ON COLUMN "users"."collectionentries"."sort" IS NULL;


COMMENT ON COLUMN "users"."collectionentries"."type" IS NULL;


COMMENT ON COLUMN "users"."collectionentries"."item_id" IS NULL;


COMMENT ON COLUMN "users"."collectionentries"."created_at" IS NULL;


COMMENT ON COLUMN "users"."collectionentries"."updated_at" IS NULL;

COMMENT ON CONSTRAINT "collectionentries_pk" ON "users"."collectionentries" IS NULL;


COMMENT ON CONSTRAINT "collectionentries_collections_id_fk" ON "users"."collectionentries" IS NULL;

COMMENT ON TABLE "users"."collectionentries" IS NULL;

--- END CREATE TABLE "users"."collectionentries" ---


-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-03-03T08:24:38.094Z             ***/
/***********************************************************/

--- BEGIN DROP TABLE "users"."collectionentries" ---

ALTER TABLE public.applications
    DROP COLUMN uuid CASCADE;

DROP TABLE IF EXISTS "users"."collectionentries";

--- END DROP TABLE "users"."collectionentries" ---

--- BEGIN DROP TABLE "users"."collections" ---

DROP TABLE IF EXISTS "users"."collections";

--- END DROP TABLE "users"."collections" ---
