import { createAuth0 } from '@auth0/auth0-vue'

export default defineNuxtPlugin(() => {
	const config = useRuntimeConfig()
	const { vueApp } = useNuxtApp()

	const auth0 = createAuth0({
		clientId: config.public.auth0.clientId,
		domain: config.public.auth0.domain,
	})

	vueApp.use(auth0)
})