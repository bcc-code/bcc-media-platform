import config from '@/config'
import { cacheExchange, createClient, fetchExchange } from '@urql/vue'
import { AuthConfig, authExchange, AuthUtilities } from '@urql/exchange-auth'
import { Auth } from '../services/auth'
import { current } from '@/services/language'
import { currentApp as currentApp } from '@/services/app'
import { webViewMain } from '@/services/webviews/mainHandler'
import { getFeatureFlags } from '@/services/feature-flags'

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
        didAuthError() {
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
    url: config.api.url + '/query',
    fetchOptions: () => {
        const headers: HeadersInit = {
            'Accept-Language': current.value.code,
            'X-Application': currentApp.value
        }

        const featureFlags = getFeatureFlags()
        if (featureFlags) {
            headers['X-Feature-Flags'] = featureFlags
        }

        return { headers }
    },
    exchanges: [
        cacheExchange,
        authExchange(authExchangeFunction),
        fetchExchange,
    ],
})
