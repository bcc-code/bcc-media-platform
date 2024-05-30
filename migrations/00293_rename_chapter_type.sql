-- +goose Up

ALTER TABLE public.timedmetadata
    RENAME COLUMN chapter_type TO content_type;

UPDATE public.directus_fields
SET field = 'content_type'::varchar(64)
WHERE id = 1299::integer;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Song","value":"song"},{"text":"Sing along","value":"sing_along"},{"text":"Speech","value":"speech"},{"text":"Testimony","value":"testimony"},{"text":"Appeal","value":"appeal"},{"text":"Panel","value":"panel"},{"text":"Theme","value":"theme"}],"allowNone":true}' WHERE "id" = 484;

UPDATE public.mediaitems SET content_type = NULL;

-- +goose Down

UPDATE public.directus_fields
SET field = 'chapter_type'::varchar(64)
WHERE id = 1299::integer;

ALTER TABLE public.timedmetadata
    RENAME COLUMN content_type TO chapter_type;

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Other transmission","value":"other_transmission"},{"text":"Event transmission","value":"event_transmission"},{"text":"Individual film","value":"individual_film"},{"text":"Series film","value":"series_film"}]}' WHERE "id" = 484;
