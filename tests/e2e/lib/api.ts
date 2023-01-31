import fetch from "node-fetch"
import { api } from "lib/config"

export const query = async (
    query: string,
    variables: {
        [key: string]: number | string
    },
    headers?: {
        [key: string]: string
    }
) => {
    headers = Object.assign(
        {
            "Content-Type": "application/json",
        },
        headers
    )

    const result = await fetch(api.endpoint, {
        method: "POST",
        headers,
        body: JSON.stringify({ query, variables }),
    })

    return await result.json()
}
