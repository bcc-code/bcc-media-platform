-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-10-03T11:55:17.642Z             ***/
/***********************************************************/

GRANT ALL PRIVILEGES ON public.timedmetadata TO background_worker;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2023-10-03T11:55:19.386Z             ***/
/***********************************************************/

