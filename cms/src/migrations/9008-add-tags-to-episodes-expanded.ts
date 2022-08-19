import { Knex } from "knex"

const replace_view_sql = `
create or replace view episodes_expanded
            (id, asset_id, episode_number, image_file_id, season_id, type, title, description, extra_description,
             published, available_from, available_to, usergroups, download_groups, early_access_groups, tag_ids)
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
       tags.tags                            AS tag_ids
FROM episodes e
         LEFT JOIN t ON e.id = t.episodes_id
         LEFT JOIN episodes_access ea ON ea.id = e.id
         LEFT JOIN tags ON tags.episodes_id = e.id;`



module.exports = {
	async up(k : Knex) {
		await k.raw(replace_view_sql)
	},

	async down(k : Knex) {

	}
}