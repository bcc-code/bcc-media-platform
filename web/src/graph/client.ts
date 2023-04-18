import config from "@/config"
import {
    cacheExchange,
    createClient,
    dedupExchange,
    fetchExchange,
} from "@urql/vue"
import { AuthConfig, authExchange, AuthUtilities } from "@urql/exchange-auth"
import { Auth } from "../services/auth"
import { current } from "@/services/language"
import { flutter } from "@/utils/flutter"

const authExchangeFunction = async (
    utils: AuthUtilities
): Promise<AuthConfig> => {
    let token = await Auth.getToken()
    return {
        willAuthError(): boolean {
            return true
        },
        addAuthToOperation(operation) {
            if (!token) return operation
            return utils.appendHeaders(operation, {
                Authorization: `Bearer ${token}`,
            })
        },
        didAuthError(error, operation): boolean {
            return false
        },
        async refreshAuth() {
            token = flutter
                ? await flutter.getAccessToken()
                : await Auth.getToken()
        },
    }
}

export default createClient({
    url: config.api.url + "/query",
    maskTypename: false,
    fetch(input, init) {
        return fetch(
            input,
            Object.assign(init ?? {}, {
                headers: Object.assign(init?.headers ?? {}, {
                    "Accept-Language": current.value.code,
                }),
            })
        )
    },
    exchanges: [
        dedupExchange,
        cacheExchange,
        authExchange(authExchangeFunction),
        fetchExchange,
    ],
})
