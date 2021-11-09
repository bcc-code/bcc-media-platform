CREATE SCHEMA admin;
ALTER SCHEMA admin OWNER TO postgres;

CREATE OR REPLACE VIEW admin.tag AS
SELECT 
    tg.id as id,
    tg.type,
    t.id as translation_id,
    t.language_code,
    t.title
FROM public.tag tg
LEFT JOIN public.tag_t t ON t.tag_id = tg.id AND t.language_code = 'no';

CREATE OR REPLACE VIEW admin.collectable AS
SELECT 
    c.id, c.type, c.available_from, c.available_to, c.status, c.created_at, c.updated_at, c.published_time,
    (select array_agg(tag_id) from public.tag_collectable where tag_collectable.collectable_id = c.id)::bigint[] AS tags,
    (select array_agg(usergroup_id) from usergroup_collectable where usergroup_collectable.collectable_id = c.id)::text[] AS usergroups
FROM public.collectable c;

CREATE OR REPLACE VIEW admin.media AS
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
    m.id, m.collectable_type, m.media_type, m.primary_group_id, m.subclipped_media_id, m.reference_media_id, m.sequence_number, m.start_time, m.end_time, m.asset_id, m.agerating, m.created_at, m.updated_at,
    c.published_time,
    c.usergroups
FROM media m
JOIN admin.collectable c USING (id)
LEFT JOIN media_t t ON t.media_id = m.id AND language_code = 'no';

DROP VIEW media_collectable;
DROP VIEW collectable_v;