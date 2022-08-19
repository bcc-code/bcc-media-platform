-- name: listEpisodes :many
SELECT * FROM public.episodes_expanded;

-- name: getEpisodes :many
SELECT * FROM public.episodes_expanded WHERE id = ANY($1::int[]);

-- name: getEpisodesForSeasons :many
SELECT * FROM public.episodes_expanded WHERE season_id = ANY($1::int[]);

-- name: RefreshEpisodeAccessView :one
SELECT update_access('episodes_access');
