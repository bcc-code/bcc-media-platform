-- +goose Up
-- Write actions performed through the admin API, one row per audited field.
CREATE TABLE users.admin_audit_log
(
    id                bigserial   NOT NULL,
    created_at        timestamptz NOT NULL DEFAULT now(),
    -- Field path, e.g. access.createApiKey.
    action            text        NOT NULL,
    arguments         jsonb       NOT NULL DEFAULT '{}',
    auth_method       text        NOT NULL CHECK (auth_method IN ('user', 'apiKey', 'directus')),
    -- directus_users.id; no FK because Directus owns that table.
    user_id           uuid,
    user_email        text,
    -- No FK so entries outlive the key.
    api_key_id        uuid,
    api_key_name      text,
    -- Caller-reported x-admin-user header on API key requests; not verified.
    admin_user_header text,
    success           boolean     NOT NULL,
    error             text,
    PRIMARY KEY (id)
);

CREATE INDEX admin_audit_log_created_at_idx ON users.admin_audit_log (created_at DESC);

GRANT SELECT, INSERT ON TABLE users.admin_audit_log TO api;
GRANT USAGE ON SEQUENCE users.admin_audit_log_id_seq TO api;

-- +goose Down
DROP TABLE users.admin_audit_log;
