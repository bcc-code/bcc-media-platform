// Runs after auth.global, so the session (and user) is already loaded.
export default defineNuxtRouteMiddleware(() => {
  const { isSuperuser } = useAuth()
  if (!isSuperuser.value) return navigateTo('/')
})
