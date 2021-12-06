CREATE OR REPLACE VIEW admin.page AS
SELECT 
    c.status,
    c.type,
    c.available_from,
    c.available_to,
	t.title,
	t.description,
	t.id as translation_id,
    p.id, p.collectable_type,
    c.published_time,
    c.usergroups,
    c.tags
FROM page p
JOIN admin.collectable c USING (id)
LEFT JOIN page_t t ON t.page_id = p.id AND language_code = 'no'