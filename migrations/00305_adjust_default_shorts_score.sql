-- +goose Up

ALTER TABLE public.shorts ALTER COLUMN score SET DEFAULT '5'::real;

-- +goose Down

ALTER TABLE public.shorts ALTER COLUMN score SET DEFAULT '0'::real;
