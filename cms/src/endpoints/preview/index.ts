import { EndpointConfig, Accountability } from "@directus/shared/src/types"
import axios from "axios"

const apiPath = process.env.API_PATH;

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
            const collection = req.body.collection;

            try {

                const body = `query {
                    preview {
                        collection(collection: "${collection}", filter: ${JSON.stringify(JSON.stringify(filter))}) {
                            items {
                                id
                                title
                            }
                        }
                    }
                }`

                const result = await axios.post(apiPath + "admin", {
                    "query": body
                }, {
                    headers: {
                        "Content-Type": "application/json"
                    }
                })

                res.send(result.data.data.preview.collection.items)
                return
            } catch (e) {
                console.log(e);
                console.log("Couldn't fetch data from API")
            }

            res.status(500).send(JSON.stringify({
                error: "Couldn't fetch data from API"
            }))
        })
    }
}

export default endpointConfig