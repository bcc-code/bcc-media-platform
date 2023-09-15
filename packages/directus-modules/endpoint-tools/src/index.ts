// @ts-ignore
import type { EndpointConfig, Accountability } from "@directus/types"
import axios from "axios"
import { PubSub } from "@google-cloud/pubsub"
import { randomUUID } from "crypto"
import { CloudEvent } from "cloudevents"

const apiPath = process.env.API_PATH
const apiSecret = process.env.API_SECRET

const getAccountability = (req: any) => {
    return req.accountability as Accountability
}

const getUserId = (req: any) => {
    try {
        return getAccountability(req).user ?? null
    } catch {
        return null
    }
}

const postQuery = async (query: string, variables: any) => {
    return await axios.post(
        apiPath + "admin",
        {
            query: query,
            variables: variables,
        },
        {
            headers: {
                "Content-Type": "application/json",
                "X-Api-Key": apiSecret,
            },
        }
    )
}

const projectId = process.env.PUBSUB_PROJECT_ID
const topicId = process.env.PUBSUB_TOPIC_ID
const pubsub = new PubSub({ projectId })

const endpointConfig: EndpointConfig = {
    id: "tools",
    handler: (router) => {
        router.post("/preview/collection", async (req, res) => {
            const userId = getUserId(req)
            if (userId == null) {
                res.status(401).send("Unauthenticated")
                return
            }
            const filter = req.body.filter

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
                    filter: JSON.stringify(filter),
                })

                res.send(result.data.data.preview.collection.items)
                return
            } catch (e) {
                console.log(e)
                console.log("Couldn't fetch data from API")
            }

            res.status(500).send(
                JSON.stringify({
                    error: "Couldn't fetch data from API",
                })
            )
        })

        router.get("/preview/asset/:assetId", async (req, res) => {
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
                    assetId: req.params["assetId"],
                })

                res.status(200).send(result.data.data.preview.asset)
                return
            } catch {
                console.log("Couldn't fetch data from API")
            }

            res.status(500).send(
                JSON.stringify({
                    error: "Couldn't fetch data from API",
                })
            )
        })

        router.post("/timedmetadata/import", async (req: any, res: any) => {
            const userId = getUserId(req)
            if (userId == null) {
                res.status(401).send("Unauthenticated")
                return
            }

            const { episodeId } = req.body as {
                episodeId: string
            }

            try {
                const body = `query($episodeId: ID!) {
    episodes {
        importTimedMetadata(episodeId: $episodeId)
    }
}`

                const result = await postQuery(body, {
                    episodeId,
                })

                console.log(result.data)

                res.status(200).send(
                    result.data.data.episodes.importTimedMetadata
                )
                return
            } catch (e) {
                console.log("Couldn't fetch data from API")
                console.error(e)
            }

            res.status(500).send(
                JSON.stringify({
                    error: "Couldn't fetch data from API",
                })
            )
        })

        router.get("/filters/refresh", async (req, res) => {
            const userId = getUserId(req)
            if (userId == null) {
                res.status(401).send("Unauthenticated")
                return
            }

            const topic = pubsub.topic(topicId!)

            const event = new CloudEvent({
                specversion: "1.0",
                id: randomUUID(),
                type: "view.refresh",
                source: "directus",
                datacontenttype: "application/json",
                data: {
                    viewName: "filter_dataset",
                    force: false,
                },
            })

            await topic.publishMessage({
                data: Buffer.from(JSON.stringify(event)),
            })

            res.status(200).send()
        })

        router.get("/translations/sync", async (req, res) => {
            const userId = getUserId(req)
            if (userId == null) {
                res.status(401).send("Unauthenticated")
                return
            }

            const topic = pubsub.topic(topicId!)

            const event = new CloudEvent({
                specversion: "1.0",
                id: randomUUID(),
                type: "translations.sync",
                source: "directus",
                datacontenttype: "application/json",
            })

            await topic.publishMessage({
                data: Buffer.from(JSON.stringify(event)),
            })

            res.status(200).send()
        })
    },
}

export default endpointConfig
