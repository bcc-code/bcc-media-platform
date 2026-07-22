export default defineNuxtRouteMiddleware(async (to) => {
  if (to.path === '/login') return

  const { ensureAuthenticated } = useAuth()

  if (!(await ensureAuthenticated())) {
    return navigateTo({ path: '/login', query: { redirect: to.fullPath } })
  }
})
