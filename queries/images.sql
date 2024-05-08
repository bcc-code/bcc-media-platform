
-- name: InsertStyledImage :one
INSERT INTO styledimages (
    style,
    language,
    file
) VALUES (
    @style,
    @language,
    @file
)
RETURNING id;