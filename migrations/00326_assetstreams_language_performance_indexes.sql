-- +goose Up

CREATE INDEX IF NOT EXISTS idx_assetstreams_audio_languages_stream_lang
    ON assetstreams_audio_languages (assetstreams_id, languages_code);

CREATE INDEX IF NOT EXISTS idx_assetstreams_subtitle_languages_filtered
    ON assetstreams_subtitle_languages (assetstreams_id)
    WHERE languages_code IS NOT NULL;

-- +goose Down

DROP INDEX IF EXISTS idx_assetstreams_subtitle_languages_filtered;
DROP INDEX IF EXISTS idx_assetstreams_audio_languages_stream_lang;
