import { defineInterface } from '@directus/extensions-sdk';
import InterfaceComponent from './interface.vue';

export default defineInterface({
	id: 'video-preview',
	name: 'Video Preview',
	icon: 'box',
	description: 'Video preview interface!',
	component: InterfaceComponent,
	options: null,
	types: ['string', "alias"],
});
