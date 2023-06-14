-- +goose Up
UPDATE directus_fields SET special = 'date-created' WHERE field = 'date_created';

-- +goose Down
