import { useAuth0 } from "@/services/auth0"
import { time } from "console";

type Token = {
    expiresAt: string;
    token: string;
}

export class Auth {
    public static async signIn() {
        const { loginWithRedirect } = useAuth0()
        return await loginWithRedirect()
    }

    private static _token: Token | null = JSON.parse(localStorage.getItem("token") ?? "null");

    public static async getToken() {
        console.log("TOk")
        if (!this.isAuthenticated().value) {
            return null
        }
        if (this._token) {
            const date = new Date(this._token.expiresAt)
            if (date.getTime() > new Date().getTime())
                return this._token.token
        }
        try {
            const { getAccessTokenSilently } = useAuth0()
            const date = new Date();
            date.setHours(date.getHours() + 12)
            this._token = {
                expiresAt: date.toISOString(),
                token: await getAccessTokenSilently(),
            }
            localStorage.setItem("token", JSON.stringify(this._token))
            return this._token.token
        } finally {

        }
    }

    public static  isAuthenticated() {
        const { isAuthenticated } = useAuth0();
        return isAuthenticated
    }
}

export default Auth
