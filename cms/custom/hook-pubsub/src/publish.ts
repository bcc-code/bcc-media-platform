import { PubSub } from "@google-cloud/pubsub"
import { Collection, Event } from "."
import { CloudEvent } from "cloudevents"
// @ts-ignore
import { ActionHandler } from "@directus/types"
import { v4 as uuid } from "uuid"

const projectId = process.env.PUBSUB_PROJECT_ID
const topicId = process.env.PUBSUB_TOPIC_ID
const pubsub = new PubSub({projectId})

export function handleEvent(eventName: string) {
    console.log("Registering PUBSUB hook for event: " + eventName)
    const handler: ActionHandler = async (event: Event) => {
        console.log("Executing hook for event: " + JSON.stringify(event))

        // const collections = [
        //     "shows",
        //     "seasons",
        //     "episodes",
        //     "sections",
        //     "shows_translations",
        //     "seasons_translations",
        //     "episodes_translations",
        //     "sections_translations",
        //     "globalconfig",
        //     "appconfig",
        //     "webconfig",
        //     "maintenancemessage",
        //     "notifications",
        //     "messages",
        // ] as Collection[]
        //
        // if (!collections.includes(event.collection)) { return }

        const keys = [] as string[]

        if (event.key) {
            keys.push(event.key.toString())
        }

        if (event.keys) {
            keys.push(...event.keys.map(i => i.toString()))
        }

        const topic = pubsub.topic(topicId)

        for (const key of keys) {
            const e = new CloudEvent({
                id: uuid(),
                type: "directus.event",
                source: "directus",
                data: {
                    event: eventName,
                    collection: event.collection,
                    id: key,
               }
            })

            console.log("Pushing event: " + JSON.stringify(e))
            await topic.publishMessage({
                data: Buffer.from(JSON.stringify(e))
            })
        }
    }
    return handler
}
