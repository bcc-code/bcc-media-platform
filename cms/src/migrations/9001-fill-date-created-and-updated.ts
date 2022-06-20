import { Knex } from 'knex';

const tables = [
	'ageratings',
	'assetfiles',
	'assets',
	'assetstreams',
	'calendarevent',
	'categories',
	'collections',
	'episodes',
	'lists',
	'pages',
	'seasons',
	'sections',
	'shows',
	'tags',
	'tvguideentry',
	'usergroups',
]

module.exports = {
	async up(k : Knex) {
		for (let i in tables) {
			await k.raw(`UPDATE ${tables[i]} SET date_created = NOW() WHERE date_created IS NULL`)
			await k.raw(`UPDATE ${tables[i]} SET date_updated = NOW() WHERE date_updated IS NULL`)
		}
	},

	async down(_ : Knex) {
		// Nothing to do. We can not delete the dates
	}
}
