import { useAuth0 } from "@auth0/auth0-vue"

const { loginWithRedirect, getAccessTokenSilently } = useAuth0()

export class Auth {
    public signIn() {
        return loginWithRedirect()
    }

    public getToken() {
        return getAccessTokenSilently()
    }
}

export default new Auth()