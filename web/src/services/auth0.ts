import { auth0 } from "@/config"
import { createAuth0 } from "@auth0/auth0-vue"

const plugin = createAuth0({
    domain: auth0.domain,
    clientId: auth0.clientId,
    cacheLocation: "localstorage",
    useRefreshTokens: true,
    authorizationParams: {
        audience: auth0.audience,
        redirect_uri: location.origin,
        scope: "church profile country",
    },
})

export default plugin

export const useAuth0 = () => {
    return plugin
}
