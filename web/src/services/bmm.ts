import {
	DefaultConfig,
	Configuration,
	StatisticsApi,
	type ProcessWatchedCommandEvent,
} from '@bcc-code/bmm-sdk-fetch'
import Auth from './auth'
import i18n from '@/i18n'
import { analytics } from './analytics'

DefaultConfig.config = new Configuration({
	basePath: 'https://bmm-api.brunstad.org',
	middleware: [
		{
			pre: async (ctx) => {
				const token = Auth.isAuthenticated().value
					? await Auth.getToken()
					: null

				const headers = new Headers(ctx.init.headers)
				if (token) {
					headers.set('Authorization', `Bearer ${token}`)
				}

				if (!headers.has('Accept-Language')) {
					const language =
						typeof i18n.global.locale === 'string'
							? i18n.global.locale
							: i18n.global.locale.value

					headers.set('Accept-Language', language)
				}

				ctx.init.headers = headers

				return ctx
			},
			post: async (ctx) => {
				if (
					!ctx.response ||
					ctx.response.status < 200 ||
					ctx.response.status > 300
				) {
					const responseContent = await ctx.response.text()
					try {
						const errorObject = JSON.parse(responseContent)
						analytics.track('error', {
							code: ctx.response.status,
							message: '[BMM] could not complete request',
							data: errorObject
						})
						console.error(errorObject)
					} catch {
						console.error(responseContent)
					}
				}
			},
			onError: async (ctx) => {
				const responseContent = await ctx.response?.text()
				try {
					const errorObject = JSON.parse(responseContent ?? '')
					analytics.track('error', {
						code: ctx.response?.status,
						message: '[BMM] an error occured',
						data: errorObject
					})
					console.error(errorObject)
				} catch {
					console.error(responseContent)
				}
			},
		},
	],
})

export class BMM {
	async postStatisticsWatched(event: ProcessWatchedCommandEvent) {
		return new StatisticsApi().statisticsWatchedPost({
			processWatchedCommandEvent: [event],
		})
	}
}
