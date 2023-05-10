import { defineInterface } from '@directus/extensions-sdk';
import InterfaceComponent from './interface.vue';

export default defineInterface({
	id: 'query-builder',
	name: 'Query Builder',
	icon: 'box',
	description: 'Query Builder',
	component: InterfaceComponent,
	options: [
		{
			field: 'fieldCollection',
			name: 'Field Collection (tablename)',
			type: 'string',
			meta: {
				interface: 'input',
				width: 'half',
				required: true,
			},
			schema: {
				default_value: "",
			},
		},
	],
	types: ["json"],
});
