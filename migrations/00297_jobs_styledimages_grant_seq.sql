-- +goose Up
GRANT USAGE ON SEQUENCE "public"."timedmetadata_styledimages_id_seq" TO background_worker;

-- +goose Down
REVOKE USAGE ON SEQUENCE "public"."timedmetadata_styledimages_id_seq" FROM background_worker;
