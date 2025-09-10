import { PlayerFactory } from "bccm-video-player"

export default defineNuxtPlugin(() => {
	const config = useRuntimeConfig()
	const { getToken } = useAuth()

	const playerFactory = new PlayerFactory({
		endpoint: config.public.apiUrl + '/query',
		tokenFactory: () => getToken(),
		application: 'bccm-web'
	})

	return {
		provide: {
			playerFactory,
		},
	}
})