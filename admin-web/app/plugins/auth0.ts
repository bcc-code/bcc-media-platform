import { createAuth0 } from '@auth0/auth0-vue'

export default defineNuxtPlugin({
  name: 'auth0',
  setup(nuxtApp) {
    const config = useRuntimeConfig()

    const auth0 = createAuth0({
      domain: config.public.auth0Domain,
      clientId: config.public.auth0ClientId,
      authorizationParams: {
        redirect_uri: window.location.origin,
        audience: 'api.bcc.no',
        scope: 'church profile country openid'
      }
    })

    nuxtApp.vueApp.use(auth0)
  }
})
