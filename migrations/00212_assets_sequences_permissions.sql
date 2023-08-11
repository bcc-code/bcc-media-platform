-- +goose Up
GRANT USAGE, UPDATE ON SEQUENCE "assets_id_seq", "assetfiles_id_seq", "assetstreams_audio_languages_id_seq", "assetstreams_id_seq", "assetstreams_subtitle_languages_id_seq" TO background_worker;

-- +goose Down
