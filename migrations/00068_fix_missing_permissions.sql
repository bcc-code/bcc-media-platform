-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T10:22:36.018Z             ***/
/***********************************************************/

GRANT SELECT, UPDATE, INSERT, DELETE ON "public"."notificationtemplates" TO directus;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-11-16T10:22:37.343Z             ***/
/***********************************************************/

SELECT 1;
