-- +goose Up

-- Foreign keys joined by the files/streams queries, previously unindexed.
CREATE INDEX IF NOT EXISTS assetfiles_asset_id_index
    ON public.assetfiles (asset_id);

CREATE INDEX IF NOT EXISTS mediaitems_assets_mediaitems_id_index
    ON public.mediaitems_assets (mediaitems_id);

CREATE INDEX IF NOT EXISTS assetstreams_asset_id_index
    ON public.assetstreams (asset_id);

-- +goose Down
DROP INDEX IF EXISTS assetfiles_asset_id_index;
DROP INDEX IF EXISTS mediaitems_assets_mediaitems_id_index;
DROP INDEX IF EXISTS assetstreams_asset_id_index;
