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

type AuthState = {
    token: string
}

export default createClient({
    url: config.api.url,
    maskTypename: false,
    exchanges: [
        dedupExchange,
        cacheExchange,
        authExchange({
            willAuthError: (_) => {
                // Ensure that a token is retrieved on every request. Auth0 SDK handles caching and handling
                return true;
            },
            getAuth: async (state) => {
                const token = await Auth.getToken();
                if (token) {
                    state.authState = {token};
                } else {
                    state.authState = null
                }
                return state
            },
            addAuthToOperation: (state) => {
                const authState = state.authState as null | AuthState

                console.log(authState);

                if (!authState || !authState.token) {
                    return state.operation
                }

                const fetchOptions = state.operation.context
                    .fetchOptions as RequestInit ?? {}

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
