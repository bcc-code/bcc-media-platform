import { authExchange } from '@urql/exchange-auth'
import urql, { Client, cacheExchange, fetchExchange } from '@urql/vue'

export default defineNuxtPlugin({
  name: 'urql',
  setup(nuxtApp) {
    const config = useRuntimeConfig()
    const { getAccessToken, refresh } = useAuth()

    const client = new Client({
      url: config.public.apiUrl,
      exchanges: [
        cacheExchange,
        authExchange(async (utils) => {
          let token = await getAccessToken()

          return {
            addAuthToOperation(operation) {
              if (!token) return operation
              return utils.appendHeaders(operation, {
                authorization: `Bearer ${token}`
              })
            },
            didAuthError(error) {
              return error.response?.status === 401
            },
            async refreshAuth() {
              token = await refresh()
              if (!token) {
                await navigateTo('/login')
              }
            }
          }
        }),
        fetchExchange
      ],
      preferGetMethod: false
    })

    nuxtApp.vueApp.use(urql, client)
  }
})
