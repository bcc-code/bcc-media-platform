-- +goose Up

GRANT ALL ON surveys_translations_id_seq TO background_worker, directus;

GRANT ALL ON surveyquestions_translations_id_seq TO background_worker, directus;

GRANT ALL ON surveyquestions_translations TO background_worker, directus;

GRANT ALL ON surveys_translations TO background_worker, directus;

-- +goose Down
