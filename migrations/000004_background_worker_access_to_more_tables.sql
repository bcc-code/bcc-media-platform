-- +goose Up

GRANT SELECT ON TABLE public.directus_files TO background_worker;

-- +goose Down

-- No OP
