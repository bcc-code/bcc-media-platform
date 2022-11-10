-- name: ListEpisodeTranslations :many
WITH episodes AS (SELECT e.id
                  FROM episodes e
                           LEFT JOIN seasons s ON s.id = e.season_id
                           LEFT JOIN shows sh ON sh.id = s.show_id
                  WHERE e.status = 'published'
                    AND s.status = 'published'
                    AND sh.status = 'published')
SELECT et.id, episodes_id as parent_id, languages_code, title, description, extra_description
FROM episodes_translations et
         JOIN episodes e ON e.id = et.episodes_id
WHERE et.languages_code = ANY($1::varchar[]);

-- name: ListSeasonTranslations :many
WITH seasons AS (SELECT s.id
                 FROM seasons s
                          LEFT JOIN shows sh ON sh.id = s.show_id
                 WHERE s.status = 'published'
                   AND sh.status = 'published')
SELECT et.id, seasons_id as parent_id, languages_code, title, description
FROM seasons_translations et
         JOIN seasons e ON e.id = et.seasons_id
WHERE et.languages_code = ANY($1::varchar[]);

-- name: ListShowTranslations :many
WITH shows AS (SELECT s.id
               FROM shows s
               WHERE s.status = 'published')
SELECT et.id, shows_id as parent_id, languages_code, title, description
FROM shows_translations et
         JOIN shows e ON e.id = et.shows_id
WHERE et.languages_code = ANY($1::varchar[]);

-- name: ListSectionTranslations :many
WITH sections AS (SELECT s.id
               FROM sections s
               WHERE s.status = 'published')
SELECT st.id, sections_id as parent_id, languages_code, title, description
FROM sections_translations st
         JOIN sections e ON e.id = st.sections_id
WHERE st.languages_code = ANY($1::varchar[]);
