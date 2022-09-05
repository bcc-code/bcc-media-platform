import config from "@/config";
import { createAuth0 } from "@auth0/auth0-vue";

const auth0 = createAuth0({
    domain: config.auth0.domain,
    client_id: config.auth0.clientId,
    redirect_uri: window.location.origin,
})

export default auth0;

export const useAuth0 = () => {
    return auth0;
}
