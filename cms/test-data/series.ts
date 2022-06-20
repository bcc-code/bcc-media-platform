import { Directus } from '@directus/sdk';
import { BTVTypes } from './types'
import { faker } from '@faker-js/faker';

const directus = new Directus<BTVTypes>(process.env.DU_HOST, {
	auth: {
		staticToken: process.env.DU_TOKEN, // You need to set this in the DU instance, and your env
	},
});

async function makeShow() {
	// We don't need to authenticate if data is public
	const show = await directus.items('shows').createOne({
		status: "published",
		translations: [{title: faker.company.catchPhrase(), languages_code: "no"}],
		type: "series",
		publish_date: faker.date.recent().toJSON(),
	})

	return show.id
}

async function makeSeasons(showId : number, count : number) : Promise<Array<number>> {
	let out = []
	for (let i = 1; i <= count; i++) {
		let s = await directus.items('seasons').createOne({
			status: "published",
			show_id: showId,
			translations: [
				{title: faker.commerce.productName(), description: faker.hacker.phrase(), languages_code: "no"},
			],
			season_number: i,
			publish_date: faker.date.between(faker.date.recent(), faker.date.soon()).toJSON(),
		})
		out.push(s.id!)
	}

	return out
}

async function makeEpisodes(seasonId: number, count : number) : Promise<Array<number>> {
	let out = []
	for (let i = 1; i <= count; i++) {
		let s = await directus.items('episodes').createOne({
			status: "published",
			season_id: seasonId,
			translations: [
				{title: faker.commerce.productName(), description: faker.hacker.phrase(), languages_code: "no"},
			],
			episode_number: i,
			publish_date: faker.date.recent().toJSON(),
		})
		out.push(s.id!)
	}

	return out
}

async function start() {
	let show = await makeShow()
	let seasons = await makeSeasons(show, 3)

	for (let i in seasons) {
		await makeEpisodes(seasons[i], 10)
	}
}

start();

