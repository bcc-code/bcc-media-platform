import { Knex } from 'knex';

const episodes_expanded_sql = `
create or replace view episodes_expanded
            (id, asset_id, episode_number, image_file_id, season_id, type, title, description, extra_description,
             published, available_from, available_to, usergroups, download_groups, early_access_groups, tag_ids, legacy_id)
as
WITH t AS (SELECT t_1.episodes_id,
                  json_object_agg(t_1.languages_code, t_1.title)             AS title,
                  json_object_agg(t_1.languages_code, t_1.description)       AS description,
                  json_object_agg(t_1.languages_code, t_1.extra_description) AS extra_description
           FROM episodes_translations t_1
           GROUP BY t_1.episodes_id),
     tags AS (SELECT tags_1.episodes_id,
                     array_agg(tags_1.tags_id) AS tags
              FROM episodes_tags tags_1
              GROUP BY tags_1.episodes_id)
SELECT e.id,
       e.asset_id,
       e.episode_number,
       e.image_file_id,
       e.season_id,
       e.type,
       t.title,
       t.description,
       t.extra_description,
       ea.published,
       ea.available_from::timestamp with time zone AS available_from,
       ea.available_to::timestamp with time zone   AS available_to,
       ea.usergroups::text[]                       AS usergroups,
       ea.usergroups_downloads::text[]             AS download_groups,
       ea.usergroups_earlyaccess::text[]           AS early_access_groups,
       tags.tags                            AS tag_ids,
       e.legacy_id
FROM episodes e
         LEFT JOIN t ON e.id = t.episodes_id
         LEFT JOIN episodes_access ea ON ea.id = e.id
         LEFT JOIN tags ON tags.episodes_id = e.id;
`

const seasons_expanded_sql = `
create or replace view seasons_expanded
            (id, season_number, image_file_id, show_id, title, description, published, available_from, available_to,
             usergroups, download_groups, early_access_groups, legacy_id)
as
WITH t AS (SELECT t_1.seasons_id,
                  json_object_agg(t_1.languages_code, t_1.title)       AS title,
                  json_object_agg(t_1.languages_code, t_1.description) AS description
           FROM seasons_translations t_1
           GROUP BY t_1.seasons_id)
SELECT se.id,
       se.season_number,
       se.image_file_id,
       se.show_id,
       t.title,
       t.description,
       access.published,
       access.available_from::timestamp with time zone AS available_from,
       access.available_to::timestamp with time zone   AS available_to,
       access.usergroups::text[]                       AS usergroups,
       access.usergroups_downloads::text[]             AS download_groups,
       access.usergroups_earlyaccess::text[]           AS early_access_groups,
       se.legacy_id
FROM seasons se
         JOIN t ON se.id = t.seasons_id
         JOIN seasons_access access ON access.id = se.id;
`

const shows_expanded_sql = `
create or replace view shows_expanded
            (id, image_file_id, title, description, published, available_from, available_to, usergroups,
             download_groups, early_access_groups, legacy_id)
as
WITH t AS (SELECT t_1.shows_id,
                  json_object_agg(t_1.languages_code, t_1.title)       AS title,
                  json_object_agg(t_1.languages_code, t_1.description) AS description
           FROM shows_translations t_1
           GROUP BY t_1.shows_id)
SELECT sh.id,
       sh.image_file_id,
       t.title,
       t.description,
       access.published,
       access.available_from::timestamp with time zone AS available_from,
       access.available_to::timestamp with time zone   AS available_to,
       access.usergroups::text[]                       AS usergroups,
       access.usergroups_downloads::text[]             AS download_groups,
       access.usergroups_earlyaccess::text[]           AS early_access_groups,
       sh.legacy_id
FROM shows sh
         JOIN t ON sh.id = t.shows_id
         JOIN shows_access access ON access.id = sh.id;
`

module.exports = {
    async up(k : Knex) {
        await k.raw(episodes_expanded_sql)
        await k.raw(seasons_expanded_sql)
        await k.raw(shows_expanded_sql)
    },

    async down(k : Knex) {
    }
}
