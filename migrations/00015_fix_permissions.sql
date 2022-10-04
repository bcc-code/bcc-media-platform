-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-04T09:29:27.748Z             ***/
/***********************************************************/

GRANT SELECT ON shows_tags TO background_worker;

GRANT SELECT ON seasons_tags TO background_worker;

-- +goose Down
