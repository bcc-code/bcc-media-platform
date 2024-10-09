import { PubSub } from "@google-cloud/pubsub"
import { CloudEvent } from "cloudevents"
import { ActionHandler } from "@directus/types"
import { randomUUID }  from "crypto";

const projectId = process.env.PUBSUB_PROJECT_ID
const topicId = process.env.PUBSUB_TOPIC_ID
const pubsub = new PubSub({projectId})

export function handleEvent(eventName: string) {
    console.log("Registering PUBSUB hook for event: " + eventName)
    const handler: ActionHandler = async (event: Record<string, any>) => {
        console.log("Executing hook for event: " + JSON.stringify(event))

        const keys = [] as string[]

        if (event.key) {
            keys.push(event.key.toString())
        }

        if (event.keys) {
            keys.push(...event.keys.map((i: any) => i.toString()))
        }

        const topic = pubsub.topic(topicId!)

        for (const key of keys) {
            const e = new CloudEvent({
                id: randomUUID(),
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
