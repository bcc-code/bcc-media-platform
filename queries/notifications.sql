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
                GROUP BY item_id),
     target_ids AS (SELECT notifications_id, array_agg(targets_id)::uuid[] AS targets
                    FROM notifications_targets
                    GROUP BY notifications_id)
SELECT n.id,
       n.status,
       COALESCE(ts.title, '{}')                                                               AS title,
       COALESCE(ts.description, '{}')                                                         AS description,
       COALESCE(img.json, '[]')                                                               AS images,
       n.action,
       n.deep_link,
       n.schedule_at,
       n.send_started,
       n.send_completed,
       n.high_priority,
       ti.targets                                                                             AS target_ids,
       coalesce(ag.id, (SELECT a.group_id FROM applications a WHERE a.default LIMIT 1))::uuid AS application_group_id,
       ag.firebase_project_id
FROM notifications n
         LEFT JOIN notificationtemplates t ON n.template_id = t.id
         LEFT JOIN ts ON ts.notificationtemplates_id = t.id
         LEFT JOIN images img ON img.item_id = t.id
         LEFT JOIN target_ids ti ON ti.notifications_id = n.id
         LEFT JOIN applicationgroups ag ON ag.id = n.applicationgroup_id
WHERE n.id = ANY ($1::uuid[]);

-- name: NotificationMarkSendStarted :exec
UPDATE notifications n
SET send_started = NOW()
WHERE id = $1;

-- name: NotificationMarkSendCompleted :exec
UPDATE notifications n
SET send_completed = NOW()
WHERE id = $1;
