-- +goose Up
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_deployments" TO directus;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_deployment_projects" TO directus;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_deployment_runs" TO directus;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_comments" TO directus;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_deployments" FROM directus;
REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_deployment_projects" FROM directus;
REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_deployment_runs" FROM directus;
REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE "public"."directus_comments" FROM directus;
