-- name: getShows :many
SELECT * FROM shows_expanded WHERE id = ANY($1::int[]);

-- name: listShows :many
SELECT * FROM shows_expanded;

-- name: RefreshShowAccessView :one
SELECT update_access('shows_access');
