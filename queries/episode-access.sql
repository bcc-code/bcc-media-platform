-- name: ListUsergroups :many
SELECT code, name
FROM usergroups
ORDER BY sort NULLS LAST, code;

-- name: InsertMissingUsergroups :exec
INSERT INTO usergroups (code, name)
SELECT c, c
FROM unnest(@codes::varchar[]) c
ON CONFLICT (code) DO NOTHING;

-- name: AddMediaItemUsergroups :exec
INSERT INTO mediaitems_usergroups (mediaitems_id, usergroups_code)
SELECT @id::uuid, unnest(@codes::varchar[])
ON CONFLICT (mediaitems_id, usergroups_code) DO NOTHING;

-- name: AddMediaItemDownloadUsergroups :exec
INSERT INTO mediaitems_usergroups_download (mediaitems_id, usergroups_code)
SELECT @id::uuid, unnest(@codes::varchar[])
ON CONFLICT (mediaitems_id, usergroups_code) DO NOTHING;

-- name: AddMediaItemEarlyAccessUsergroups :exec
INSERT INTO mediaitems_usergroups_earlyaccess (mediaitems_id, usergroups_code)
SELECT @id::uuid, unnest(@codes::varchar[])
ON CONFLICT (mediaitems_id, usergroups_code) DO NOTHING;

-- name: RemoveMediaItemUsergroups :exec
DELETE
FROM mediaitems_usergroups
WHERE mediaitems_id = @id::uuid
  AND usergroups_code = ANY (@codes::varchar[]);

-- name: RemoveMediaItemDownloadUsergroups :exec
DELETE
FROM mediaitems_usergroups_download
WHERE mediaitems_id = @id::uuid
  AND usergroups_code = ANY (@codes::varchar[]);

-- name: RemoveMediaItemEarlyAccessUsergroups :exec
DELETE
FROM mediaitems_usergroups_earlyaccess
WHERE mediaitems_id = @id::uuid
  AND usergroups_code = ANY (@codes::varchar[]);
