-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-14T14:37:31.016Z             ***/
/***********************************************************/

alter materialized view public.filter_dataset owner to background_worker;

grant all on sequence events_translations_id_seq to background_worker;
grant all on sequence mediaitems_translations_id_seq to background_worker;
GRANT ALL ON SEQUENCE calendarentries_translations_id_seq TO background_worker;
GRANT SELECT ON games_usergroups TO background_worker;

-- +goose Down
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2024-03-14T14:37:32.813Z             ***/
/***********************************************************/

