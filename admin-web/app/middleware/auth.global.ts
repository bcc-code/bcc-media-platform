import { useAuth0 } from '@auth0/auth0-vue'

export default defineNuxtRouteMiddleware(async () => {
  const { isAuthenticated, isLoading, loginWithRedirect } = useAuth0()

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
    await new Promise(() => {})
  }
})
