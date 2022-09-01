import { Directus } from '@directus/sdk';
import { BTVTypes } from './types'
import { faker } from '@faker-js/faker';

const directus = new Directus<BTVTypes>(process.env.DU_HOST, {});

function getRandomDate() {
	let date = new Date()
	date.setHours(0)
	date.setMinutes(0)
	date.setSeconds(0)
	date.setMilliseconds(0)
	let increment = Math.floor(Math.random() * 10)
	if (Math.random() >= 0.5) {
		increment = increment * -1
	}
	date.setDate(date.getDate() + increment)
	return date
}

function getRandomDateGreaterThan(date: Date) {
	let newDate = new Date(date)
	let increment = 5 + Math.floor(Math.random() * 100)
	newDate.setDate(date.getDate() + increment)
	return newDate
}

async function makeShow() {
	// We don't need to authenticate if data is public
	const item: any = {
		status: "published",
			translations: [{title: faker.company.catchPhrase(), languages_code: "no"}],
		type: "series",
		publish_date: faker.date.recent().toJSON(),
	}

	if (Math.random() > 0.3) {
		const availableFrom = getRandomDate()
		const availableTo = getRandomDateGreaterThan(availableFrom)
		item.available_from = availableFrom.toISOString()
		item.available_to = availableTo.toISOString()
	}

	const show = await directus.items('shows').createOne(item)

	return show.id
}

async function makeSeasons(showId : number, count : number) : Promise<Array<number>> {
	let out = []
	for (let i = 1; i <= count; i++) {
		const item: any = {
			status: "published",
			show_id: showId,
			translations: [
				{title: faker.commerce.productName(), description: faker.hacker.phrase(), languages_code: "no"},
			],
			season_number: i,
			publish_date: faker.date.between(faker.date.recent(), faker.date.soon()).toJSON(),
		}

		if (Math.random() > 0.3) {
			const availableFrom = getRandomDate()
			const availableTo = getRandomDateGreaterThan(availableFrom)
			item.available_from = availableFrom.toISOString()
			item.available_to = availableTo.toISOString()
		}

		let s = await directus.items('seasons').createOne(item)
		console.log(s)
		out.push(s.id!)
	}

	return out
}

async function makeEpisodes(seasonId: number, count : number) : Promise<Array<number>> {
	let out = []
	for (let i = 1; i <= count; i++) {
		const item: any = {
			status: "published",
			season_id: seasonId,
			translations: [
				{title: faker.commerce.productName(), description: faker.hacker.phrase(), languages_code: "no"},
			],
			episode_number: i,
			publish_date: faker.date.recent().toJSON(),
		}

		if (Math.random() > 0.3) {
			const availableFrom = getRandomDate()
			const availableTo = getRandomDateGreaterThan(availableFrom)
			item.available_from = availableFrom.toISOString()
			item.available_to = availableTo.toISOString()
		}

		let s = await directus.items('episodes').createOne(item)
		out.push(s.id!)
	}

	return out
}

async function start() {
	await directus.auth.login({
		email: process.env.DU_ADMIN_EMAIL,
		password: process.env.DU_ADMIN_PASS,
	});
	let show = await makeShow()
	let seasons = await makeSeasons(show, 3)

	for (let i in seasons) {
		await makeEpisodes(seasons[i], 10)
	}
}

start();

