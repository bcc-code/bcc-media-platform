-- +goose Up

GRANT SELECT ON TABLE "public"."applications" TO background_worker;

-- +goose Down
