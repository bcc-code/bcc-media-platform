import { EndpointConfig, Accountability } from "@directus/shared/src/types"

const apiKey = process.env.GRAPH_API_KEY;

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
        router.get("/:id", (req, res) => {
            const userId = getUserId(req)
            if (userId == null) {
                res.status(401).send("Unauthenticated")
                return
            }
            
            const fileId = req.params["id"]
            res.send("")
        })
    }
}

export default endpointConfig