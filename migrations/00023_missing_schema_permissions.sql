-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-05T09:22:01.320Z             ***/
/***********************************************************/

GRANT USAGE ON SCHEMA "users" TO api;
GRANT USAGE ON SCHEMA "users" TO background_worker;

-- +goose Down
