import config from "@/config"
import { cacheExchange, createClient, fetchExchange } from "@urql/vue"
import { AuthConfig, authExchange, AuthUtilities } from "@urql/exchange-auth"
import { Auth } from "../services/auth"
import { current } from "@/services/language"
import { currentApp as currentApp } from "@/services/app"
import { webViewMain } from "@/services/webviews/mainHandler"

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
            token = webViewMain
                ? await webViewMain.getAccessToken()
                : await Auth.getToken()
        },
    }
}

export default createClient({
    url: config.api.url + "/query",
    fetch(input, init) {
        return fetch(
            input,
            Object.assign(init ?? {}, {
                headers: Object.assign(init?.headers ?? {}, {
                    "Accept-Language": current.value.code,
                    "X-Application": currentApp.value,
                }),
            })
        )
    },
    exchanges: [
        cacheExchange,
        authExchange(authExchangeFunction),
        fetchExchange,
    ],
})
