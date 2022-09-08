-- +goose Up

GRANT SELECT ON TABLE public.goose_db_version TO directus;

-- +goose Down

-- No OP
