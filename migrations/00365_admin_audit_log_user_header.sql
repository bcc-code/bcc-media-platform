-- +goose Up
-- Caller-reported x-user header, required on audited API key calls; not verified.
ALTER TABLE users.admin_audit_log RENAME COLUMN admin_user_header TO user_header;

-- +goose Down
ALTER TABLE users.admin_audit_log RENAME COLUMN user_header TO admin_user_header;
