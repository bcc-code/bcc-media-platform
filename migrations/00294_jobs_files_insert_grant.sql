-- +goose Up
GRANT INSERT ON TABLE "public"."directus_files" TO background_worker;
GRANT UPDATE ON TABLE "public"."directus_files" TO background_worker;

-- +goose Down
REVOKE INSERT ON TABLE "public"."directus_files" FROM background_worker;
REVOKE UPDATE ON TABLE "public"."directus_files" FROM background_worker;

