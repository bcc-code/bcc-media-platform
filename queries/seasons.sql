-- name: getSeasons :many
SELECT * FROM seasons_expanded WHERE id = ANY($1::int[]);

-- name: getSeasonsForShows :many
SELECT * FROM seasons_expanded WHERE show_id = ANY($1::int[]);

-- name: listSeasons :many
SELECT * FROM seasons_expanded;

-- name: RefreshSeasonAccessView :one
SELECT update_access('seasons_access');