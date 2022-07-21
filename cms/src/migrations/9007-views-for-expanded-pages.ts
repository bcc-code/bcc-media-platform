import { Knex } from 'knex';

const sections_expanded_sql = `
create or replace view sections_expanded (id, page, type, published, date_created, date_updated, collection_id, title) as
WITH t AS (SELECT t_1.sections_id,
                  json_object_agg(t_1.languages_code, t_1.title) AS title
           FROM sections_translations t_1
           GROUP BY t_1.sections_id)
SELECT s.id,
       s.page,
       s.type,
       s.status::text = 'published'::text AS published,
       s.date_created,
       s.date_updated,
       s.collection_id,
       t.title
FROM sections s
         JOIN t ON s.id = t.sections_id;
`

const collections_expanded_sql = `
create or replace view collections_expanded(id, date_created, date_updated, title) as
WITH t AS (SELECT t_1.collections_id,
                  json_object_agg(t_1.languages_code, t_1.title) AS title
           FROM collections_translations t_1
           GROUP BY t_1.collections_id)
SELECT c.id,
       c.date_created,
       c.date_updated,
       t.title
FROM collections c
         JOIN t ON c.id = t.collections_id;
`

module.exports = {
	async up(k : Knex) {
		await k.raw(sections_expanded_sql)
		await k.raw(collections_expanded_sql)
	},

	async down(k : Knex) {
		await k.raw(`DROP VIEW sections_expanded`)
		await k.raw(`DROP VIEW collections_expanded`)
	}
}
