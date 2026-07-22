// Directus-backed authentication for the admin panel.
//
// We log users in against Directus (`POST /auth/login`, cookie mode): Directus
// keeps the refresh token in an httpOnly cookie and returns a short-lived
// access token, which we hold in memory and send as a Bearer token to the
// admin GraphQL API. On reload the in-memory token is gone but the refresh
// cookie survives, so `getAccessToken()` transparently mints a new one.

interface DirectusUser {
  id: string
  email: string
  first_name: string | null
  last_name: string | null
  avatar: string | null
}

interface AuthResponse {
  data: {
    access_token: string
    // Milliseconds until the access token expires.
    expires: number
  }
}

// Module-scoped singleton state. This is a client-only SPA (ssr: false), so a
// single shared instance across the app is exactly what we want.
const accessToken = ref<string | null>(null)
const expiresAt = ref<number | null>(null)
const currentUser = ref<DirectusUser | null>(null)

// De-dupes concurrent refreshes (e.g. the router middleware and urql racing on
// first load) so only one `/auth/refresh` call is in flight at a time.
let refreshPromise: Promise<string | null> | null = null

// Refresh this many milliseconds before the token actually expires, to avoid
// racing the clock on in-flight requests.
const EXPIRY_MARGIN_MS = 10_000

export function useAuth() {
  const directusUrl = useRuntimeConfig().public.directusUrl

  function request<T>(
    path: string,
    options: Parameters<typeof $fetch>[1] = {}
  ) {
    return $fetch<T>(`${directusUrl}${path}`, {
      // Send/receive the Directus refresh-token cookie.
      credentials: 'include',
      ...options
    })
  }

  function setSession(token: string, expiresInMs: number) {
    accessToken.value = token
    expiresAt.value = Date.now() + expiresInMs
  }

  function clearSession() {
    accessToken.value = null
    expiresAt.value = null
    currentUser.value = null
  }

  async function login(email: string, password: string) {
    const res = await request<AuthResponse>('/auth/login', {
      method: 'POST',
      body: { email, password, mode: 'cookie' }
    })
    setSession(res.data.access_token, res.data.expires)
    await fetchCurrentUser()
  }

  async function refresh(): Promise<string | null> {
    if (refreshPromise) return refreshPromise
    refreshPromise = (async () => {
      try {
        const res = await request<AuthResponse>('/auth/refresh', {
          method: 'POST',
          body: { mode: 'cookie' }
        })
        setSession(res.data.access_token, res.data.expires)
        return res.data.access_token
      } catch {
        clearSession()
        return null
      } finally {
        refreshPromise = null
      }
    })()
    return refreshPromise
  }

  // Returns a valid access token, refreshing via the cookie when the current
  // one is missing or about to expire. Null means the user must log in again.
  async function getAccessToken(): Promise<string | null> {
    if (
      accessToken.value &&
      expiresAt.value &&
      Date.now() < expiresAt.value - EXPIRY_MARGIN_MS
    ) {
      return accessToken.value
    }
    return refresh()
  }

  async function fetchCurrentUser() {
    const res = await request<{ data: DirectusUser }>(
      '/users/me?fields=id,email,first_name,last_name,avatar',
      { headers: { Authorization: `Bearer ${accessToken.value}` } }
    )
    currentUser.value = res.data
  }

  // Restores/validates the session for route guards. Returns whether the user
  // is authenticated.
  async function ensureAuthenticated(): Promise<boolean> {
    const token = await getAccessToken()
    if (!token) return false
    if (!currentUser.value) {
      try {
        await fetchCurrentUser()
      } catch {
        return false
      }
    }
    return true
  }

  async function logout() {
    try {
      await request('/auth/logout', {
        method: 'POST',
        body: { mode: 'cookie' }
      })
    } finally {
      clearSession()
    }
  }

  function avatarUrl(): string | undefined {
    return currentUser.value?.avatar
      ? `${directusUrl}/assets/${currentUser.value.avatar}`
      : undefined
  }

  return {
    currentUser: readonly(currentUser),
    isAuthenticated: computed(() => !!accessToken.value),
    login,
    logout,
    refresh,
    getAccessToken,
    ensureAuthenticated,
    avatarUrl
  }
}
