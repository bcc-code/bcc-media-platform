CREATE VIEW media_collectable AS
SELECT 
    c.status,
    c.type,
    c.available_from,
    c.available_to,
    m.*
FROM media m
JOIN collectable c USING (id)
JOIN media_t t ON t.media_id = m.id AND language_code = 'no'