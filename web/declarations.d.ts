import type {
	ComponentCustomOptions as _ComponentCustomOptions,
	ComponentCustomProperties as _ComponentCustomProperties,
} from 'vue';

declare module '@vue/runtime-core' {
	interface ComponentCustomProperties extends _ComponentCustomProperties { }
	interface ComponentCustomOptions extends _ComponentCustomOptions { }
}

declare module 'bccm-video-player' {
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	const content: any;
	export default content;
	export = content;
}