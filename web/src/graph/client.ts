import config from "@/config"
import {
    cacheExchange,
    createClient,
    dedupExchange,
    fetchExchange,
} from "@urql/vue"
import { authExchange } from "@urql/exchange-auth"
import { makeOperation } from "@urql/vue"
import Auth from "../services/auth"
import { current } from "@/services/language"
import { flutter } from "@/utils/flutter"

type AuthState = {
    token: string
}

function getApiUrl() {
    const query = new URLSearchParams(location.search);
    const envOverride = query.get('env_override')?.replace(/[^a-zA-Z0-9]/g, "");
    if (envOverride && envOverride != 'none') {
        return {
            'prod': 'https://api.brunstad.tv',
            'sta': 'https://api.sta.brunstad.tv',
            'dev': 'https://api.dev.brunstad.tv',
        }[envOverride]
    }
    return config.api.url;
}
const apiUrl = getApiUrl();

export default createClient({
    url: apiUrl + "/query",
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
        authExchange({
            willAuthError: (_) => {
                // Ensure that a token is retrieved on every request. Auth0 SDK handles caching and errors
                return true
            },
            getAuth: async (state) => {
                if (flutter) {
                    const token = await flutter.getAccessToken()
                    if (token) {
                        state.authState = { token }
                    } else {
                        state.authState = null
                    }
                    return state
                }
                const token = await Auth.getToken()
                if (token) {
                    state.authState = { token }
                } else {
                    state.authState = null
                }
                return state
            },
            addAuthToOperation: (state) => {
                const { authState } = state.authState as {
                    authState: AuthState | null
                }

                if (!authState || !authState.token) {
                    return state.operation
                }

                const fetchOptions =
                    (state.operation.context.fetchOptions as RequestInit) ?? {}

                return makeOperation(state.operation.kind, state.operation, {
                    ...state.operation.context,
                    fetchOptions: {
                        ...fetchOptions,
                        headers: {
                            ...fetchOptions.headers,
                            Authorization: "Bearer " + authState.token,
                        },
                    },
                })
            },
        }),
        fetchExchange,
    ],
})
