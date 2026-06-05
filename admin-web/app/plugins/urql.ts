import { useAuth0 } from '@auth0/auth0-vue'
import { authExchange } from '@urql/exchange-auth'
import urql, { Client, cacheExchange, fetchExchange } from '@urql/vue'

export default defineNuxtPlugin({
  name: 'urql',
  dependsOn: ['auth0'],
  setup(nuxtApp) {
    const config = useRuntimeConfig()
    const {
      getAccessTokenSilently,
      isAuthenticated,
      isLoading,
      loginWithRedirect
    } = useAuth0()

    const waitForAuth = async () => {
      if (isLoading.value) {
        await new Promise<void>((resolve) => {
          const stop = watch(isLoading, (loading) => {
            if (!loading) {
              stop()
              resolve()
            }
          })
        })
      }
      if (!isAuthenticated.value) {
        await loginWithRedirect({
          appState: { target: window.location.pathname }
        })
      }
    }

    const client = new Client({
      url: config.public.apiUrl,
      exchanges: [
        cacheExchange,
        authExchange(async (utils) => {
          await waitForAuth()
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
              await waitForAuth()
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
