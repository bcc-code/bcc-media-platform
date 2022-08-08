-- name: ListShows :many
SELECT * FROM public.shows_expanded;

-- name: GetShows :many
SELECT * FROM public.shows_expanded WHERE id = ANY($1::int[]);

-- name: RefreshShowAccessView :one
SELECT update_access('shows_access');
