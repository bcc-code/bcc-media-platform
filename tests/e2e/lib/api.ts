import fetch from "node-fetch"
import { api } from "lib/config"

export const query = async (
    query: string,
    variables: {
        [key: string]: number | string
    }
) => {
    const headers = {
        "Content-Type": "application/json",
    }

    const result = await fetch(api.endpoint, {
        method: "POST",
        headers,
        body: JSON.stringify({ query, variables }),
    })

    return await result.json()
}
