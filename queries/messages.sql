-- name: getMessageGroups :many
WITH ts AS (SELECT messagetemplates_id,
                   json_object_agg(languages_code, message) AS message,
                   json_object_agg(languages_code, details) AS details
            FROM messagetemplates_translations
            GROUP BY messagetemplates_id),
     msg AS (SELECT mt.id, mt.status, mt.style, mm.messages_id, ts.message, ts.details
             FROM messagetemplates mt
                      JOIN messages_messagetemplates mm on mt.id = mm.messagetemplates_id
                      JOIN ts ON ts.messagetemplates_id = mt.id
             WHERE mt.status = 'published')
SELECT groups.id, groups.enabled, json_agg(msg) as messages
FROM messages groups
         JOIN msg ON msg.messages_id = groups.id
WHERE groups.status = 'published'
  AND groups.id = ANY ($1::int[])
GROUP BY groups.id, groups.enabled;

-- name: GetSectionIDsWithMessageIDs :many
SELECT s.id
FROM sections s
         JOIN messages m ON m.id = s.message_id
WHERE m.id = ANY ($1::int[]);
