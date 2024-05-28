-- +goose Up
GRANT USAGE ON SEQUENCE "public"."contributions_id_seq" TO background_worker;

GRANT SELECT ON TABLE "public"."contributions" TO background_worker;
GRANT INSERT ON TABLE "public"."contributions" TO background_worker;
GRANT UPDATE ON TABLE "public"."contributions" TO background_worker;
GRANT DELETE ON TABLE "public"."contributions" TO background_worker;

-- +goose Down
REVOKE SELECT ON TABLE "public"."contributions" FROM background_worker;
REVOKE INSERT ON TABLE "public"."contributions" FROM background_worker;
REVOKE UPDATE ON TABLE "public"."contributions" FROM background_worker;
REVOKE DELETE ON TABLE "public"."contributions" FROM background_worker;

REVOKE USAGE ON SEQUENCE "public"."contributions_id_seq" FROM background_worker;
