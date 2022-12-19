-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-19T12:34:43.565Z             ***/
/***********************************************************/

GRANT SELECT ON TABLE "public"."studytopics" TO background_worker;
GRANT SELECT ON TABLE "public"."lessons" TO background_worker;
GRANT SELECT ON TABLE "public"."tasks" TO background_worker;
GRANT SELECT ON TABLE "public"."questionalternatives" TO background_worker;

-- +goose Down
