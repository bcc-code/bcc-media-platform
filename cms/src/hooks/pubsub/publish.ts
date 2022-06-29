import { PubSub } from "@google-cloud/pubsub"
import { Collection, Event } from "."
import { CloudEvent } from "cloudevents"

const projectId = process.env.PUBSUB_PROJECT_ID

export function handleEvent(eventName: string) {
    return async (event: Event) => {
        const collections = ["shows", "seasons", "episodes", "shows_translations", "seasons_translations", "episodes_translations"] as Collection[]

        if (collections.includes(event.collection)) {
            const ids: number[] = []
            if (event.key) {
                ids.push(Number(event.key))
            }
            if (event.keys) {
                ids.push(...event.keys.map(k => Number(k)))
            }
            const pubsub = new PubSub({projectId})

            const topic = pubsub.topic("background-jobs")

            const e = new CloudEvent({
                type: "directus.event",
                source: "directus",
                data: {
                    event: eventName,
                    collection: event.collection,
                    ids,
                }
            })

            await topic.publishMessage({
                data: Buffer.from(JSON.stringify(e))
            })
        }
    }
}