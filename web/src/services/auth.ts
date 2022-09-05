import { useAuth0 } from "@/services/auth0"

export class Auth {
    public static signIn() {
        const { loginWithRedirect } = useAuth0()
        return loginWithRedirect()
    }

    private static _token: string | null = null

    public static async getToken() {
        const { getAccessTokenSilently, isAuthenticated } = useAuth0()
        if (!isAuthenticated.value) {
            return null
        }
        if (this._token) {
            return this._token
        }
        try {
            return this._token = await getAccessTokenSilently()
        } finally {
            if (this._token) {
                setTimeout(() => this._token = null, 32000)
            }
        }
    }
}

export default Auth
