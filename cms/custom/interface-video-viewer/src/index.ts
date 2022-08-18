import { defineInterface } from '@directus/extensions-sdk';
import InterfaceComponent from './interface.vue';
import "media-chrome";

export default defineInterface({
	id: 'video-preview',
	name: 'Video Preview',
	icon: 'play_arrow',
	description: 'Video preview interface!',	
	component: InterfaceComponent,
	options: null,
	types: ["alias"],
	localTypes: ["presentation", "standard"],
	group: "presentation"
});
