import fetch from "node-fetch"

export const query = async (
    query: string,
    variables: {
        [key: string]: number | string
    }
) => {
    const headers = {
        "Content-Type": "application/json",
    }

    const result = await fetch(process.env.API_ENDPOINT!, {
        method: "POST",
        headers,
        body: JSON.stringify({ query, variables }),
    })

    return await result.json()
}
