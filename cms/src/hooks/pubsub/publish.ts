import { PubSub } from "@google-cloud/pubsub"
import { Collection, Event } from "."
import { CloudEvent } from "cloudevents"
import { ActionHandler } from "@directus/shared/src/types"
import { v4 as uuid } from "uuid"

const projectId = process.env.PUBSUB_PROJECT_ID
const topicId = process.env.PUBSUB_TOPIC_ID
const pubsub = new PubSub({projectId})

export function handleEvent(eventName: string) {
    console.log("Registering PUBSUB hook for event: " + eventName)
    const handler: ActionHandler = async (event: Event) => {
        const collections = ["shows", "seasons", "episodes", "shows_translations", "seasons_translations", "episodes_translations"] as Collection[]

        if (!collections.includes(event.collection)) { return }
        
        // Use show, season or episode ID as ids.
        if (!event.key) {
            event.key = event.keys.map(i => Number(i))[0]
        }
        const topic = pubsub.topic(topicId)
        const e = new CloudEvent({
            id: uuid(),
            type: "directus.event",
            source: "directus",
            data: {
                event: eventName,
                collection: event.collection,
                id: event.key,
           }
        })

        await topic.publishMessage({
            data: Buffer.from(JSON.stringify(e))
        })
    }
    return handler
}