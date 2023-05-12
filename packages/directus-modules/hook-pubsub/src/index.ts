import { handleEvent } from "./publish";
import { defineHook } from "@directus/extensions-sdk"

type Translation = "shows_translations" | "seasons_translations" | "episodes_translations"
type Object = "shows" | "seasons" | "episodes" | "messages"
type Singleton = "globalconfig" | "appconfig" | "webconfig" | "maintenancemessage"

export type Collection = Translation | Object | Singleton

export interface Event {
    key: number | string;
    keys: (number | string)[]
    payload: any;
    collection: Collection;
}

export default defineHook(({action}, context) => {
    if (!process.env.PUBSUB_PROJECT_ID) {
        console.log("Missing configuration for publishing hooks to pubsub")
        return
    }

    action("items.create", handleEvent("items.create"))
    action("items.update", handleEvent("items.update"))
    action("items.delete", handleEvent("items.delete"))
})
