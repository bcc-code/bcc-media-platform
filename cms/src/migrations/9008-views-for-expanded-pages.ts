import { Knex } from 'knex';

const add_pages_translations_table = `
create table pages_translations
(
    id             serial
        primary key,
    pages_id       integer
        constraint pages_translations_pages_id_foreign
            references pages
            on delete set null,
    languages_code varchar(255)
        constraint pages_translations_languages_code_foreign
            references languages
            on delete set null,
    title          varchar(255),
    description    varchar(255)
);
`

const add_section_description = `
alter table sections_translations
    add description varchar(255);
`

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

module.exports = {
    async up(k: Knex) {
        await k.raw(add_pages_translations_table)
        await k.raw(add_section_description)
        await k.raw(sections_expanded_sql)
        await k.raw(pages_expanded_sql)
    },

    async down(k: Knex) {
        await k.raw(`DROP VIEW sections_expanded`)
        await k.raw(`DROP VIEW pages_expanded`)
    }
}
