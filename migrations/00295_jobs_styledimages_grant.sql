-- +goose Up
GRANT INSERT ON TABLE "public"."styledimages" TO background_worker;
GRANT UPDATE ON TABLE "public"."styledimages" TO background_worker;
GRANT DELETE ON TABLE "public"."styledimages" TO background_worker;

GRANT INSERT ON TABLE "public"."timedmetadata_styledimages" TO background_worker;
GRANT UPDATE ON TABLE "public"."timedmetadata_styledimages" TO background_worker;
GRANT DELETE ON TABLE "public"."timedmetadata_styledimages" TO background_worker;

-- +goose Down
REVOKE INSERT ON TABLE "public"."styledimages" FROM background_worker;
REVOKE UPDATE ON TABLE "public"."styledimages" FROM background_worker;
REVOKE DELETE ON TABLE "public"."styledimages" FROM background_worker;

REVOKE INSERT ON TABLE "public"."timedmetadata_styledimages" FROM background_worker;
REVOKE UPDATE ON TABLE "public"."timedmetadata_styledimages" FROM background_worker;
REVOKE DELETE ON TABLE "public"."timedmetadata_styledimages" FROM background_worker;

