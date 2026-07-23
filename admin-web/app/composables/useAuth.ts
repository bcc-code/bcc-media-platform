// Authentication via the admin GraphQL API's `auth` mutations
// (backend/graph/admin). The API proxies credentials to Directus server-side
// and mints its own short-lived access token, which we hold in memory and
// send as a Bearer token on GraphQL requests. The refresh token lives in an
// httpOnly cookie scoped to /admin, so on reload `getAccessToken()`
// transparently mints a new session — login and refresh both return the user.
//
// These calls go through $fetch rather than urql: urql's authExchange calls
// refresh() itself, so auth can't depend on the urql client.

interface AdminUser {
  id: string
  email: string
  firstName: string | null
  lastName: string | null
  avatarUrl: string | null
}

interface AuthResult {
  accessToken: string
  // Milliseconds until the access token expires.
  expiresInMs: number
  user: AdminUser
}

const AUTH_RESULT_FIELDS = `
  accessToken
  expiresInMs
  user {
    id
    email
    firstName
    lastName
    avatarUrl
  }
`

const LOGIN_MUTATION = `
  mutation Login($email: String!, $password: String!) {
    auth {
      login(email: $email, password: $password) {
        ${AUTH_RESULT_FIELDS}
      }
    }
  }
`

const REFRESH_MUTATION = `
  mutation Refresh {
    auth {
      refresh {
        ${AUTH_RESULT_FIELDS}
      }
    }
  }
`

const LOGOUT_MUTATION = `
  mutation Logout {
    auth {
      logout
    }
  }
`

// Module-scoped singleton state. This is a client-only SPA (ssr: false), so a
// single shared instance across the app is exactly what we want.
const accessToken = ref<string | null>(null)
const expiresAt = ref<number | null>(null)
const currentUser = ref<AdminUser | null>(null)

// De-dupes concurrent refreshes (e.g. the router middleware and urql racing on
// first load) so only one refresh mutation is in flight at a time.
let refreshPromise: Promise<string | null> | null = null

// Refresh this many milliseconds before the token actually expires, to avoid
// racing the clock on in-flight requests.
const EXPIRY_MARGIN_MS = 10_000

export function useAuth() {
  const apiUrl = useRuntimeConfig().public.apiUrl

  // Minimal GraphQL POST; throws when the response carries errors.
  async function mutate<T>(
    query: string,
    variables?: Record<string, unknown>
  ): Promise<T> {
    const res = await $fetch<{ data?: T; errors?: { message: string }[] }>(
      `${apiUrl}/admin`,
      {
        method: 'POST',
        // Send/receive the httpOnly refresh-token cookie.
        credentials: 'include',
        body: { query, variables }
      }
    )
    if (res.errors?.length || !res.data) {
      throw new Error(res.errors?.[0]?.message ?? 'auth request failed')
    }
    return res.data
  }

  function setSession(res: AuthResult) {
    accessToken.value = res.accessToken
    expiresAt.value = Date.now() + res.expiresInMs
    currentUser.value = res.user
  }

  function clearSession() {
    accessToken.value = null
    expiresAt.value = null
    currentUser.value = null
  }

  async function login(email: string, password: string) {
    const data = await mutate<{ auth: { login: AuthResult } }>(
      LOGIN_MUTATION,
      { email, password }
    )
    setSession(data.auth.login)
  }

  async function refresh(): Promise<string | null> {
    if (refreshPromise) return refreshPromise
    refreshPromise = (async () => {
      try {
        const data =
          await mutate<{ auth: { refresh: AuthResult } }>(REFRESH_MUTATION)
        setSession(data.auth.refresh)
        return data.auth.refresh.accessToken
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

  // Restores/validates the session for route guards. Returns whether the user
  // is authenticated. The refresh result carries the user, so no separate
  // profile fetch is needed.
  async function ensureAuthenticated(): Promise<boolean> {
    return !!(await getAccessToken())
  }

  async function logout() {
    try {
      await mutate(LOGOUT_MUTATION)
    } finally {
      clearSession()
    }
  }

  function avatarUrl(): string | undefined {
    return currentUser.value?.avatarUrl ?? undefined
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
