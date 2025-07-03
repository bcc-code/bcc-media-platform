-- +goose Up

CREATE TABLE IF NOT EXISTS users.exports
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    profile_id uuid NOT NULL,
    user_groups text[] NOT NULL DEFAULT '{}'::text[],
    status text NOT NULL DEFAULT 'new',
    created_date timestamp with time zone NOT NULL DEFAULT now(),
    expiry_date timestamp with time zone,
    url text NOT NULL DEFAULT '',
    PRIMARY KEY (id),
    CONSTRAINT fk_profile FOREIGN KEY (profile_id)
        REFERENCES users.profiles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE users.exports TO api;

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE users.exports TO background_worker;

GRANT SELECT ON TABLE users.exports TO onsite_backup;

-- +goose Down

DROP TABLE users.exports;
