-- name: ListSeasons :many
SELECT * FROM public.seasons_expanded;

-- name: GetSeasons :many
SELECT * FROM public.seasons_expanded WHERE id = ANY($1::int[]);

-- name: GetSeasonsForShows :many
SELECT * FROM public.seasons_expanded WHERE show_id = ANY($1::int[]);

-- name: RefreshSeasonAccessView :one
SELECT update_access('seasons_access');