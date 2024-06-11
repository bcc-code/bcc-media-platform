-- +goose Up
GRANT SELECT ON TABLE "public"."styledimages" TO background_worker;
GRANT SELECT ON TABLE "public"."timedmetadata_styledimages" TO background_worker;

-- +goose Down
REVOKE SELECT ON TABLE "public"."styledimages" FROM background_worker;
REVOKE SELECT ON TABLE "public"."timedmetadata_styledimages" FROM background_worker;

