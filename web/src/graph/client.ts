import config from "@/config"
import { cacheExchange, createClient, dedupExchange, fetchExchange } from "@urql/vue"
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
        fetchExchange,
        cacheExchange,
        authExchange({
            getAuth: async ({authState}) => {
                if (!authState) {
                    return {
                        token: await Auth.getToken()
                    }
                }
                return null
            },
            addAuthToOperation: (state) => {
                const authState = state.authState as null | AuthState
                if (!authState || !authState.token) {
                    return state.operation
                }

                const fetchOptions = state.operation.context.fetchOptions as RequestInit

                return makeOperation(state.operation.kind, state.operation, {
                    ...state.operation.context,
                    fetchOptions: {
                        ...fetchOptions,
                        headers: {
                            ...fetchOptions.headers,
                            Authorization: "Bearer " + authState.token
                        }
                    }
                })
            }
        }),
    ]
})
