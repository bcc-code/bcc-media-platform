DROP VIEW admin.tag;
DROP VIEW admin.media;
DROP SCHEMA IF EXISTS admin CASCADE;

CREATE OR REPLACE VIEW collectable_v AS
SELECT 
    c.*,
    (select array_agg(tag_id) from public.tag_collectable where tag_collectable.collectable_id = c.id)::bigint[] AS tags,
    (select array_agg(usergroup_id) from usergroup_collectable where usergroup_collectable.collectable_id = c.id)::text[] AS usergroups
FROM collectable c;

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
    m.*,
    c.published_time,
    c.usergroups
FROM media m
JOIN collectable_v c USING (id)
LEFT JOIN media_t t ON t.media_id = m.id AND language_code = 'no';