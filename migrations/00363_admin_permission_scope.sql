-- +goose Up
ALTER TABLE users.admin_permissions
    RENAME COLUMN forced_filter TO scope;

-- +goose Down
ALTER TABLE users.admin_permissions
    RENAME COLUMN scope TO forced_filter;
