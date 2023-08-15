import { useAuth0 } from "@/services/auth0"

// type Token = {
//     expiresAt: string
//     token: string
// }

const COUNTRY_CODE_CLAIM = "https://login.bcc.no/claims/CountryIso2Code"
const CHURCH_ID_CLAIM = "https://login.bcc.no/claims/churchId"

const query = new URLSearchParams(window.location.search)

export class Auth {
    private static wasLoggedIn: string | null
    public static shouldSignIn() {
        const { isAuthenticated } = useAuth0()
        if (isAuthenticated.value) {
            return false
        }
        if (localStorage.getItem("wasLoggedIn") === "true") {
            const query = new URLSearchParams(location.search)
            if (query.get("error") === "login_required") {
                return true
            } else {
                const triedLoggingIn = localStorage.getItem("triedLoggingIn")

                let shouldLogIn = true

                if (triedLoggingIn) {
                    const date = new Date(triedLoggingIn)
                    const now = new Date()
                    now.setSeconds(now.getSeconds() - 20)
                    shouldLogIn = date.getTime() < now.getTime()
                }
                if (shouldLogIn) {
                    localStorage.setItem(
                        "triedLoggingIn",
                        new Date().toISOString()
                    )
                    Auth.signIn(true)
                }
            }
        }
        return false
    }

    public static cancelSignIn() {
        localStorage.removeItem("wasLoggedIn")
        localStorage.removeItem("triedLoggingIn")
        location.replace("/")
    }

    public static async signIn(silent?: boolean) {
        const { loginWithRedirect } = useAuth0()

        await loginWithRedirect({
            authorizationParams: {
                prompt: silent ? "none" : undefined,
            },
        })
    }

    public static async signOut() {
        const { logout } = useAuth0()
        localStorage.clear()
        return await logout({
            logoutParams: {
                returnTo: window.location.origin,
            },
        })
    }

    public static loading() {
        const { isLoading } = useAuth0()
        return isLoading
    }

    public static async getToken() {
        const { getAccessTokenSilently, isAuthenticated, loginWithRedirect } =
            useAuth0()
        if (isAuthenticated.value) {
            try {
                return await getAccessTokenSilently()
            } catch {
                await loginWithRedirect()
            }
        }
        return query.get("access_token")
    }

    public static isAuthenticated() {
        const { isAuthenticated } = useAuth0()
        if (isAuthenticated.value) {
            if (
                (this.wasLoggedIn ??= localStorage.getItem("wasLoggedIn")) !==
                "true"
            ) {
                localStorage.setItem("wasLoggedIn", "true")
            }
        }
        return isAuthenticated
    }

    public static user() {
        const { isAuthenticated, user } = useAuth0()
        // if (!isAuthenticated.value) {
        //     return null
        // }
        return user
    }

    public static getClaims() {
        const { idTokenClaims } = useAuth0()
        return {
            gender: idTokenClaims.value?.gender,
            birthDate: idTokenClaims.value?.birthdate,
            churchId: idTokenClaims.value?.[CHURCH_ID_CLAIM] as number,
            country: idTokenClaims.value?.[COUNTRY_CODE_CLAIM] as string,
        }
    }
}

export const useAuth = () => {
    return {
        signIn: Auth.signIn,
        signOut: Auth.signOut,
        loading: Auth.loading(),
        getToken: Auth.getToken,
        authenticated: Auth.isAuthenticated(),
        user: Auth.user(),
        shouldSignIn: Auth.shouldSignIn,
        cancelSignIn: Auth.cancelSignIn,
        getClaims: Auth.getClaims,
    }
}

export default Auth
