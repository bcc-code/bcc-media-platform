-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-06T13:16:51.198Z             ***/
/***********************************************************/

GRANT ALL PRIVILEGES ON SEQUENCE "playlists_translations_id_seq" TO background_worker;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-11-06T13:16:53.327Z             ***/
/***********************************************************/


