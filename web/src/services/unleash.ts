import { UnleashClient } from "@unleash/proxy-client-vue";

const appName = 'bccm-web'

export default new UnleashClient({
	url: import.meta.env.VITE_UNLEASH_URL,
	clientKey: import.meta.env.VITE_UNLEASH_CLIENT_KEY,
	refreshInterval: 60,
	appName,
	customHeaders: {
		'UNLEASH-APPNAME': appName,
	},
})