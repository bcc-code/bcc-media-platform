-- +goose Up

-- Partial indexes on contributions FK columns. Each contribution sets exactly
-- one of {mediaitem_id, timedmetadata_id, song_id}, so partial indexes keep
-- each one small and aligned with how the queries filter (every read supplies
-- a non-NULL value).
CREATE INDEX IF NOT EXISTS contributions_song_id_index
    ON public.contributions (song_id) WHERE song_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS contributions_mediaitem_id_index
    ON public.contributions (mediaitem_id) WHERE mediaitem_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS contributions_timedmetadata_id_index
    ON public.contributions (timedmetadata_id) WHERE timedmetadata_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS contributions_person_id_index
    ON public.contributions (person_id);

-- mediaitems.primary_episode_id powers GetContributionsForEpisode and the
-- person query CTE; previously only mediaitems_pkey and published_at were
-- indexed, so the planner did a full mediaitems seq scan per call.
CREATE INDEX IF NOT EXISTS mediaitems_primary_episode_id_index
    ON public.mediaitems (primary_episode_id) WHERE primary_episode_id IS NOT NULL;

-- Needed by the rewritten OR-split queries: the timedmetadata_from_asset
-- branch joins timedmetadata on asset_id, which was previously unindexed.
CREATE INDEX IF NOT EXISTS timedmetadata_asset_id_index
    ON public.timedmetadata (asset_id) WHERE asset_id IS NOT NULL;

-- +goose Down
DROP INDEX IF EXISTS contributions_song_id_index;
DROP INDEX IF EXISTS contributions_mediaitem_id_index;
DROP INDEX IF EXISTS contributions_timedmetadata_id_index;
DROP INDEX IF EXISTS contributions_person_id_index;
DROP INDEX IF EXISTS mediaitems_primary_episode_id_index;
DROP INDEX IF EXISTS timedmetadata_asset_id_index;
