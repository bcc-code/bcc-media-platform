
-- name: GetMediaSearchDocs :many
SELECT 
    m.*,
    parent.primary_group_id as grandparent_id
FROM admin.media m
LEFT JOIN admin.media parent ON parent.id = m.primary_group_id
;
