-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-19T11:53:28.525Z             ***/
/***********************************************************/

GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."links_id_seq" TO directus;
GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."links_translations_id_seq" TO directus;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-10-19T11:53:29.885Z             ***/
/***********************************************************/
