import { useAuth0 } from "@/services/auth0"

// type Token = {
//     expiresAt: string
//     token: string
// }

export class Auth {
    public static async signIn() {
        const { loginWithRedirect } = useAuth0()
        return await loginWithRedirect()
    }

    public static async signOut() {
        const { logout } = useAuth0()
        return await logout({
            returnTo: window.location.origin,
        })
    }

    public static loading() {
        const { isLoading } = useAuth0()
        return isLoading;
    }

    public static async getToken() {
        const { getAccessTokenSilently } = useAuth0()
        return getAccessTokenSilently();
    }

    public static isAuthenticated() {
        const { isAuthenticated } = useAuth0()
        return isAuthenticated
    }
}

export default Auth
