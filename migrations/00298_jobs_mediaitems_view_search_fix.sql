-- +goose Up
GRANT SELECT ON TABLE "public"."mediaitems_view" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

-- +goose Down
REVOKE SELECT ON TABLE "public"."mediaitems_view" FROM background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
