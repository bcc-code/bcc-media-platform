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
        router.get("/collection/:id", async (req, res) => {
            const userId = getUserId(req)
            if (userId == null) {
                res.status(401).send("Unauthenticated")
                return
            }
            
            const collectionId = req.params["id"]

            try {
                const result = await axios.get(apiPath + "preview/collection/" + collectionId)

                res.send(result.data)
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