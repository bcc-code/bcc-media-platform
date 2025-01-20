-- +goose Up

CREATE TABLE "public"."translations_hash" (
    "collection" text NOT NULL PRIMARY KEY,
    "hash" bytea NOT NULL,
    "last_sent" timestamp DEFAULT CURRENT_TIMESTAMP
);

GRANT SELECT ON TABLE "public"."translations_hash" TO background_worker;
GRANT INSERT ON TABLE "public"."translations_hash" TO background_worker;
GRANT UPDATE ON TABLE "public"."translations_hash" TO background_worker;
GRANT DELETE ON TABLE "public"."translations_hash" TO background_worker;

-- +goose Down

DROP TABLE IF EXISTS "public"."translations_hash";
