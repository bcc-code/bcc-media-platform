import { useAuth0 } from "@/services/auth0"

export class Auth {
    public static async signIn() {
        const { loginWithRedirect } = useAuth0()
        return await loginWithRedirect()
    }

    private static _token: string | null = null

    public static async getToken() {
        if (!this.isAuthenticated().value) {
            return null
        }
        if (this._token) {
            return this._token
        }
        try {
            const { getAccessTokenSilently } = useAuth0()
            return this._token = await getAccessTokenSilently()
        } finally {
            if (this._token) {
                setTimeout(() => this._token = null, 32000)
            }
        }
    }

    public static  isAuthenticated() {
        const { isAuthenticated } = useAuth0();
        return isAuthenticated
    }
}

export default Auth
