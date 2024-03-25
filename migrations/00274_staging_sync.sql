-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-20T12:23:14.547Z             ***/
/***********************************************************/
GRANT SELECT ON ALL TABLES IN SCHEMA public TO staging_sync;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO staging_sync;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO staging_sync;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON SEQUENCES TO staging_sync;
-- +goose Down
