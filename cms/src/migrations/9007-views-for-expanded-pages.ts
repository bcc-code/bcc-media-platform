import { Knex } from 'knex';

const sections_expanded_sql = `
create or replace view sections_expanded
            (id, page_id, style, sort, published, date_created, date_updated, collection_id, title, description,
             roles) as
WITH t AS (SELECT ts.sections_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM sections_translations ts
           GROUP BY ts.sections_id),
     u AS (SELECT ug.sections_id,
                  array_agg(ug.usergroups_code) AS roles
           FROM sections_usergroups ug
           GROUP BY ug.sections_id)
SELECT s.id,
       s.page_id,
       s.style,
       s.sort,
       s.status::text = 'published'::text AS published,
       s.date_created,
       s.date_updated,
       s.collection_id,
       t.title,
       t.description,
       u.roles
FROM sections s
         LEFT JOIN t ON s.id = t.sections_id
         LEFT JOIN u ON s.id = u.sections_id;
`

const pages_expanded_sql = `
create or replace view pages_expanded
            (id, code, type, published, show_id, season_id, episode_id, collection, title, description, roles) as
WITH t AS (SELECT ts.pages_id,
                  json_object_agg(ts.languages_code, ts.title)       AS title,
                  json_object_agg(ts.languages_code, ts.description) AS description
           FROM pages_translations ts
           GROUP BY ts.pages_id),
     r AS (SELECT p_1.id                                                   AS page_id,
                  (SELECT array_agg(DISTINCT eu.usergroups_code) AS array_agg
                   FROM sections_usergroups eu
                   WHERE (eu.sections_id IN (SELECT e.id
                                             FROM episodes e
                                             WHERE e.season_id = p_1.id))) AS roles
           FROM pages p_1)
SELECT p.id,
       p.code,
       p.type,
       p.status::text = 'published'::text AS published,
       p.show_id,
       p.season_id,
       p.episode_id,
       p.collection,
       t.title,
       t.description,
       r.roles
FROM pages p
         LEFT JOIN t ON t.pages_id = p.id
         LEFT JOIN r ON r.page_id = p.id;
`

const collections_expanded_sql = `
create or replace view collections_expanded
            (id, collection, filter_type, page_ids, pages_query_filter, show_ids, shows_query_filter, season_ids,
             seasons_query_filter, episode_ids, episodes_query_filter)
as
WITH pages AS (SELECT collections_pages.collections_id,
                      json_agg(collections_pages.pages_id) AS page_ids
               FROM collections_pages
               GROUP BY collections_pages.collections_id),
     shows AS (SELECT collections_shows.collections_id,
                      json_agg(collections_shows.shows_id) AS show_ids
               FROM collections_shows
               GROUP BY collections_shows.collections_id),
     seasons AS (SELECT collections_seasons.collections_id,
                        json_agg(collections_seasons.seasons_id) AS season_ids
                 FROM collections_seasons
                 GROUP BY collections_seasons.collections_id),
     episodes AS (SELECT collections_episodes.collections_id,
                         json_agg(collections_episodes.episodes_id) AS episode_ids
                  FROM collections_episodes
                  GROUP BY collections_episodes.collections_id)
SELECT c.id,
       c.collection,
       c.filter_type,
       p.page_ids,
       c.pages_query_filter,
       sh.show_ids,
       c.shows_query_filter,
       se.season_ids,
       c.seasons_query_filter,
       e.episode_ids,
       c.episodes_query_filter
FROM collections c
         LEFT JOIN pages p ON p.collections_id = c.id
         LEFT JOIN shows sh ON sh.collections_id = c.id
         LEFT JOIN seasons se ON se.collections_id = c.id
         LEFT JOIN episodes e ON e.collections_id = c.id;
`

module.exports = {
	async up(k : Knex) {
		await k.raw(sections_expanded_sql)
		await k.raw(pages_expanded_sql)
        await k.raw(collections_expanded_sql)
	},

	async down(k : Knex) {
		await k.raw(`DROP VIEW sections_expanded`)
		await k.raw(`DROP VIEW pages_expanded`)
        await k.raw(`DROP VIEW collections_expanded`)
	}
}
