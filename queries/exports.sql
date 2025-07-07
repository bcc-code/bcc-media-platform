-- name: InsertExport :one
INSERT INTO users.exports (
    id,
    profile_id,
    user_groups,
    status,
    created_date,
    expiry_date,
    url,
    content_only_in_preferred_language,
    preferred_audio_languages,
    preferred_subtitles_languages,
    application_id,
    application_code,
    application_clientVersion,
    application_default_page_id
) VALUES (
    DEFAULT,    
    @profile_id,
    @user_groups,
    DEFAULT,
    DEFAULT,
    DEFAULT,
    DEFAULT,
    @content_only_in_preferred_language,
    @preferred_audio_languages,
    @preferred_subtitles_languages,
    @application_id,
    @application_code,
    @application_client_version,
    @application_default_page_id
)
RETURNING *;

-- name: GetExportById :one
SELECT * FROM users.exports WHERE id = @id::uuid;

-- name: UpdateExportURL :exec
UPDATE users.exports
SET url = @url
WHERE id = @id::uuid;

-- name: UpdateExportStatus :exec
UPDATE users.exports
SET status = @status
WHERE id = @id::uuid;

-- name: UpdateExpiryDate :exec
UPDATE users.exports
SET expiry_date = @expiry_date
WHERE id = @id::uuid;
