-- +goose Up
-- Refresh-token sessions for the admin API's own auth (/auth/* on cmd/api).
-- The cookie value is an opaque random token; only its sha256 hex digest is
-- stored, so a database leak does not leak usable session tokens.
CREATE TABLE users.admin_sessions
(
    id         uuid        NOT NULL DEFAULT gen_random_uuid(),
    -- directus_users.id; no FK because Directus owns that table. The refresh
    -- handler re-validates the user on every use anyway.
    user_id    uuid        NOT NULL,
    token_hash text        NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    expires_at timestamptz NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (token_hash)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE users.admin_sessions TO api;

-- +goose Down
DROP TABLE users.admin_sessions;
