-- name: getNotifications :many
WITH ts AS (SELECT ts.notificationtemplates_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description
            FROM notificationtemplates_translations ts
            GROUP BY ts.notificationtemplates_id),
     imgs AS (SELECT notificationtemplate_id as item_id, style, language, filename_disk
              FROM images img
                       JOIN directus_files df on img.file = df.id),
     images AS (SELECT item_id, json_agg(imgs) as json
                FROM imgs
                GROUP BY item_id)
SELECT n.id,
       n.status,
       COALESCE(ts.title, '{}')       AS title,
       COALESCE(ts.description, '{}') AS description,
       COALESCE(img.json, '[]')       AS images,
       n.action,
       n.deep_link,
       n.schedule_at,
       n.sent
FROM notifications n
         LEFT JOIN notificationtemplates t ON n.template_id = t.id
         LEFT JOIN ts ON ts.notificationtemplates_id = t.id
         LEFT JOIN images img ON img.item_id = t.id
WHERE n.id = ANY ($1::uuid[]);

-- name: MarkAsSent :exec
UPDATE notifications n SET sent = true WHERE id = $1;
