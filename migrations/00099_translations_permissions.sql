-- +goose Up
/***********************************************************/
/*** SCRIPT AUTHOR: Fredrik Vedvik (fredrik@vedvik.tech) ***/
/***    CREATED ON: 2022-12-19T12:34:43.565Z             ***/
/***********************************************************/

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "public"."studytopics_translations" TO background_worker;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "public"."lessons_translations" TO background_worker;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "public"."tasks_translations" TO background_worker;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE "public"."questionalternatives_translations" TO background_worker;

-- +goose Down
