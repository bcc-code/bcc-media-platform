import { useAuth0 } from '@auth0/auth0-vue'
import { authExchange } from '@urql/exchange-auth'
import urql, { Client, cacheExchange, fetchExchange } from '@urql/vue'

export default defineNuxtPlugin({
  name: 'urql',
  dependsOn: ['auth0'],
  setup(nuxtApp) {
    const config = useRuntimeConfig()
    const { getAccessTokenSilently } = useAuth0()

    const client = new Client({
      url: config.public.apiUrl,
      exchanges: [
        cacheExchange,
        authExchange(async (utils) => {
          let token = await getAccessTokenSilently()

          return {
            addAuthToOperation(operation) {
              return utils.appendHeaders(operation, {
                authorization: `Bearer ${token}`
              })
            },
            didAuthError(error) {
              return error.response?.status === 401
            },
            async refreshAuth() {
              token = await getAccessTokenSilently({ cacheMode: 'off' })
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
