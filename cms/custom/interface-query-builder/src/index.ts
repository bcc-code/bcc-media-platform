import { defineInterface } from '@directus/extensions-sdk';
import InterfaceComponent from './interface.vue';

export default defineInterface({
	id: 'query-builder',
	name: 'Query Builder',
	icon: 'box',
	description: 'Query Builder',
	component: InterfaceComponent,
	options: null,
	types: ["json"],
});
