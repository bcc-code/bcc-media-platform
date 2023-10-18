-- +goose Up

GRANT SELECT ON TABLE "public"."playlists_styledimages" TO background_worker; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

-- +goose Down
