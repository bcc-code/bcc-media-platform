import { defineInterface } from '@directus/extensions-sdk';
import InterfaceComponent from './interface.vue';

export default defineInterface({
	id: 'custom-datepicker',
	name: 'Custom Datepicker',
	icon: 'date',
	description: 'Custom date picker',
	component: InterfaceComponent,
	options: null,
	types: ["dateTime"],
});
