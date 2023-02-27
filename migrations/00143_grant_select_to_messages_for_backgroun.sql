-- +goose Up

GRANT SELECT ON users.messages TO background_worker;

-- +goose Down

REVOKE SELECT ON users.messages FROM background_worker;
