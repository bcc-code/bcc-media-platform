-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T10:22:36.018Z             ***/
/***********************************************************/

UPDATE "public"."directus_fields" SET special = 'uuid' WHERE id = 650;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T10:22:37.343Z             ***/
/***********************************************************/

UPDATE "public"."directus_fields" SET special = null WHERE id = 650;

