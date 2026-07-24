import { authExchange } from '@urql/exchange-auth'
import urql, { Client, cacheExchange, fetchExchange } from '@urql/vue'

export default defineNuxtPlugin({
  name: 'urql',
  setup(nuxtApp) {
    const config = useRuntimeConfig()
    const { accessToken, tokenNeedsRefresh, refresh } = useAuth()

    const client = new Client({
      url: `${config.public.apiUrl}/admin`,
      exchanges: [
        cacheExchange,
        authExchange(async (utils) => {
          return {
            addAuthToOperation(operation) {
              // Read the live session state (never a snapshot) so a
              // logout/login switch takes effect on the next operation.
              const token = accessToken.value
              if (!token) return operation
              return utils.appendHeaders(operation, {
                authorization: `Bearer ${token}`
              })
            },
            willAuthError() {
              // Refresh proactively instead of waiting for the server to
              // reject an expired token.
              return tokenNeedsRefresh()
            },
            didAuthError(error) {
              // Auth failures arrive as GraphQL errors with an
              // UNAUTHENTICATED code (the endpoint responds 200).
              return (
                error.response?.status === 401 ||
                error.graphQLErrors.some(
                  (e) => e.extensions?.code === 'UNAUTHENTICATED'
                )
              )
            },
            async refreshAuth() {
              if (!(await refresh())) {
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
