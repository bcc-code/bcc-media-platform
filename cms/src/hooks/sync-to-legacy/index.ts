import { defineHook } from '@directus/extensions-sdk';

export default defineHook(({ filter, action }) => {
	filter('items.create', (...p1) => {
		console.log('Creating Item!');
		console.log(p1)
	});

	action('items.create', () => {
		console.log('Item created!');
	});
});
