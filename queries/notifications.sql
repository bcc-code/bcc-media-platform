-- name: getNotifications :many
WITH ts AS (SELECT notifications_id,
                   json_object_agg(languages_code, title)       AS title,
                   json_object_agg(languages_code, description) AS description,
                   json_object_agg(languages_code, image)       AS images
            FROM notifications_translations
            GROUP BY notifications_id)
SELECT id, status, ts.title, ts.description, ts.images
FROM notifications
         JOIN ts ON ts.notifications_id = id
WHERE id = ANY ($1::int[]);
