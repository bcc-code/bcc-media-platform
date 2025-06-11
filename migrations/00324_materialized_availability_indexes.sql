-- +goose Up
CREATE UNIQUE INDEX IF NOT EXISTS episode_availability_id_idx ON public.episode_availability (id);
CREATE UNIQUE INDEX IF NOT EXISTS season_availability_id_idx ON public.season_availability (id);
CREATE UNIQUE INDEX IF NOT EXISTS show_availability_id_idx ON public.show_availability (id);
CREATE UNIQUE INDEX IF NOT EXISTS filter_dataset_collection_id_uuid_idx ON public.filter_dataset (collection, id, uuid);

-- +goose Down
DROP INDEX IF EXISTS filter_dataset_collection_id_uuid_idx;
DROP INDEX IF EXISTS show_availability_id_idx;
DROP INDEX IF EXISTS season_availability_id_idx;
DROP INDEX IF EXISTS episode_availability_id_idx;
