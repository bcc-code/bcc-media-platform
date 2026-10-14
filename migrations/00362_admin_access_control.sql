-- +goose Up
-- API keys for the admin API. Only the sha256 hex digest of a key is stored.
CREATE TABLE users.api_keys
(
    id         uuid        NOT NULL DEFAULT gen_random_uuid(),
    name       text        NOT NULL,
    -- Leading characters of the key, so it can be recognised in lists.
    key_prefix text        NOT NULL,
    key_hash   text        NOT NULL,
    -- directus_users.id; no FK because Directus owns that table.
    created_by uuid,
    created_at timestamptz NOT NULL DEFAULT now(),
    expires_at timestamptz,
    revoked_at timestamptz,
    PRIMARY KEY (id),
    UNIQUE (key_hash)
);

-- Admin API permissions, granted to either an API key or a Directus role.
CREATE TABLE users.admin_permissions
(
    id               uuid  NOT NULL DEFAULT gen_random_uuid(),
    api_key_id       uuid REFERENCES users.api_keys (id) ON DELETE CASCADE,
    -- directus_roles.id; no FK because Directus owns that table.
    directus_role_id uuid,
    resource         text  NOT NULL,
    access           text  NOT NULL CHECK (access IN ('read', 'write')),
    -- Filters always applied for this grant, shaped like the resource's filter input.
    forced_filter    jsonb NOT NULL DEFAULT '{}',
    PRIMARY KEY (id),
    CHECK (num_nonnulls(api_key_id, directus_role_id) = 1)
);

CREATE UNIQUE INDEX admin_permissions_api_key_resource_idx
    ON users.admin_permissions (api_key_id, resource) WHERE api_key_id IS NOT NULL;
CREATE UNIQUE INDEX admin_permissions_role_resource_idx
    ON users.admin_permissions (directus_role_id, resource) WHERE directus_role_id IS NOT NULL;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE users.api_keys TO api;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE users.admin_permissions TO api;

-- +goose Down
DROP TABLE users.admin_permissions;
DROP TABLE users.api_keys;
