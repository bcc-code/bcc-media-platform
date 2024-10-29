import unleashClient from "./unleash";

export function getFeatureFlags() {
	return unleashClient.getAllToggles().map(toggle => {
		const variant = toggle.variant.name ? `:${toggle.variant.name}` : ''
		return toggle.name + variant
	}).join(',')
}