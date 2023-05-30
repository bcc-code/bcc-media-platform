-- +goose Up

ALTER TABLE assetfiles ADD COLUMN size_bigint BIGINT;
UPDATE assetfiles SET size_bigint = size;
ALTER TABLE assetfiles DROP COLUMN size;
ALTER TABLE assetfiles RENAME COLUMN size_bigint TO size;

-- +goose Down

-- NOOP, we dont want to loose data and "up" still works even if the column is already BIGINT
