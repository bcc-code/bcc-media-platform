-- +goose Up
-- Archive deletes from public.assets into public.assets_deleted_archive

-- Table to store archived rows from assets before they are deleted
CREATE TABLE IF NOT EXISTS assets_deleted_archive (
    id              bigserial PRIMARY KEY,
    asset_id        integer NOT NULL,
    name            varchar,
    duration        integer,
    encoding_version varchar,
    main_storage_path text,
    mediabanken_id  varchar,
    status          varchar,
    source          text,
    date_created    timestamptz,
    date_updated    timestamptz,
    user_created    uuid,
    user_updated    uuid,
    aws_arn         varchar,
    deleted_at      timestamptz NOT NULL DEFAULT now()
);

-- +goose StatementBegin
-- Trigger function to insert a copy of the OLD row into archive before delete
CREATE OR REPLACE FUNCTION tg_archive_assets_before_delete()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO assets_deleted_archive (
        asset_id,
        name,
        duration,
        encoding_version,
        main_storage_path,
        mediabanken_id,
        status,
        source,
        date_created,
        date_updated,
        user_created,
        user_updated,
        aws_arn
    ) VALUES (
        OLD.id,
        OLD.name,
        OLD.duration,
        OLD.encoding_version,
        OLD.main_storage_path,
        OLD.mediabanken_id,
        OLD.status,
        OLD.source,
        OLD.date_created,
        OLD.date_updated,
        OLD.user_created,
        OLD.user_updated,
        OLD.aws_arn
    );
    RETURN OLD;
END;
$$;
-- +goose StatementEnd

-- Attach the trigger to assets table
DROP TRIGGER IF EXISTS trg_assets_archive_before_delete ON assets;
CREATE TRIGGER trg_assets_archive_before_delete
    BEFORE DELETE ON assets
    FOR EACH ROW
    EXECUTE FUNCTION tg_archive_assets_before_delete();

-- Permissions per platform standard
GRANT SELECT, UPDATE, DELETE ON TABLE assets_deleted_archive TO background_worker;
GRANT SELECT, INSERT, UPDATE ON TABLE assets_deleted_archive TO directus;
GRANT USAGE, SELECT ON SEQUENCE assets_deleted_archive_id_seq TO directus;

-- +goose Down

-- Drop trigger and function, then table
DROP TRIGGER IF EXISTS trg_assets_archive_before_delete ON assets;
DROP FUNCTION IF EXISTS tg_archive_assets_before_delete();
DROP TABLE IF EXISTS assets_deleted_archive;
