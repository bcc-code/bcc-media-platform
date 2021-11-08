CREATE OR REPLACE VIEW media_collectable AS
SELECT 
    c.status,
    c.type,
    c.available_from,
    c.available_to,
	t.title,
	t.description,
	t.long_description,
	t.image_id,
	t.id as translation_id,
    m.*
FROM media m
JOIN collectable c USING (id)
LEFT JOIN media_t t ON t.media_id = m.id AND language_code = 'no'