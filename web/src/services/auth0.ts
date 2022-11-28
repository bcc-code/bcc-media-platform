import { auth0 } from "@/config"
import { createAuth0 } from "@auth0/auth0-vue"

const plugin = createAuth0({
    domain: auth0.domain,
    client_id: auth0.clientId,
    audience: auth0.audience,
    redirect_uri: location.origin,
    scope: "church profile country",
    cacheLocation: "localstorage",
    useRefreshTokens: true,
})

export default plugin

export const useAuth0 = () => {
    return plugin
}
