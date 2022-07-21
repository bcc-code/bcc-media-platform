-- name: ListSections :many
SELECT * FROM sections_expanded;

-- name: GetSections :many
SELECT * FROM sections_expanded s WHERE s.id = ANY($1::int[]);

-- name: GetSectionsForPageIDs :many
SELECT * FROM sections_expanded s WHERE s.page = ANY($1::int[]);