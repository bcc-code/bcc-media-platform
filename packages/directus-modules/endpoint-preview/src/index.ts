// @ts-ignore
import type { EndpointConfig, Accountability } from "@directus/types"
import axios from "axios"

const apiPath = process.env.API_PATH;
const apiSecret = process.env.API_SECRET;

const getAccountability = (req: any) => {
    return req.accountability as Accountability;
}

const getUserId = (req: any) => {
    try {
        return getAccountability(req).user ?? null;
    } catch {
        return null
    }
}

const postQuery = async (query: string, variables: any) => {
    return await axios.post(apiPath + "admin", {
        "query": query,
        "variables": variables,
    }, {
        headers: {
            "Content-Type": "application/json",
            "X-Api-Key": apiSecret
        }
    })
}

const endpointConfig: EndpointConfig = {
    id: "preview",
    handler: (router) => {
        router.post("/collection", async (req, res) => {
            const userId = getUserId(req)
            if (userId == null) {
                res.status(401).send("Unauthenticated")
                return
            }
            const filter = req.body.filter;

            try {

                const body = `query($filter: String!) {
    preview {
        collection(filter: $filter) {
            items {
                id
                collection
                title
            }
        }
    }
}`

                const result = await postQuery(body, {
                    "filter": JSON.stringify(filter)
                })

                res.send(result.data.data.preview.collection.items)
                return
            } catch (e) {
                console.log(e)
                console.log("Couldn't fetch data from API")
            }

            res.status(500).send(JSON.stringify({
                error: "Couldn't fetch data from API"
            }))
        });

        router.get("/asset/:assetId", async (req, res) => {
            const userId = getUserId(req)
            if (userId == null) {
                res.status(401).send("Unauthenticated")
                return
            }

            try {

                const body = `query($assetId: ID!) {
    preview {
        asset(id: $assetId) {
            url
            type
        }
    }
}`

                const result = await postQuery(body, {
                    "assetId": req.params["assetId"],
                })

                res.status(200).send(result.data.data.preview.asset)
                return
            } catch {
                console.log("Couldn't fetch data from API")
            }

            res.status(500).send(JSON.stringify({
                error: "Couldn't fetch data from API"
            }))
        })
    }
}

export default endpointConfig
