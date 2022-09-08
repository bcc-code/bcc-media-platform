-- +goose Up

GRANT SELECT ON TABLE public.tvguideentry TO directus;

-- +goose Down

-- No OP
