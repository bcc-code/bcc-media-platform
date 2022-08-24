-- name: getMaintenanceMessage :one
WITH ts AS (SELECT messagetemplates_id,
                   json_object_agg(languages_code, message) AS message,
                   json_object_agg(languages_code, details) AS details
            FROM messagetemplates_translations
            GROUP BY messagetemplates_id),
     messages AS (SELECT mt.id,
                         mm.maintenancemessage_id,
                         ts.message,
                         ts.details
                  FROM messagetemplates mt
                           LEFT JOIN ts ON ts.messagetemplates_id = mt.id
                           JOIN maintenancemessage_messagetemplates mm on mt.id = mm.messagetemplates_id)
SELECT m.id, m.active, m.date_updated, json_agg(ms) as messages
FROM maintenancemessage m
         JOIN messages ms ON ms.maintenancemessage_id = m.id
WHERE m.active
GROUP BY m.id, m.active, m.date_updated
LIMIT 1;
