-- +goose Up

GRANT SELECT ON TABLE public.directus_files TO api;

-- +goose Down

-- No OP
