-- +goose Up
GRANT INSERT, UPDATE, DELETE ON TABLE "assets" TO background_worker;
GRANT INSERT, UPDATE, DELETE ON TABLE "assetfiles" TO background_worker;
GRANT INSERT, UPDATE, DELETE ON TABLE "assetstreams_audio_languages" TO background_worker;
GRANT INSERT, UPDATE, DELETE ON TABLE "assetstreams" TO background_worker;
GRANT INSERT, UPDATE, DELETE ON TABLE "assetstreams_subtitle_languages" TO background_worker;

-- +goose Down
