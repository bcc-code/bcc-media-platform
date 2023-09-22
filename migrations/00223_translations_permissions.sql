-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-22T10:02:22.503Z             ***/
/***********************************************************/

GRANT ALL PRIVILEGES ON "pages_translations_id_seq" TO "background_worker";

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-09-22T10:02:24.410Z             ***/
/***********************************************************/

