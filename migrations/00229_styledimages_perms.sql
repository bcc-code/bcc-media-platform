-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-10-20T13:16:21.348Z             ***/
/***********************************************************/

GRANT SELECT ON TABLE "public"."styledimages" TO background_worker;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-10-20T13:16:23.235Z             ***/
/***********************************************************/
