import { handleEvent } from "./publish";
import { HookConfig } from "@directus/types"

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

const hooks: HookConfig = ({action}) => {
    if (!process.env.PUBSUB_PROJECT_ID) {
        console.log("Missing configuration for publishing hooks to pubsub")
        return
    }

    action("items.create", handleEvent("items.create"))
    action("items.update", handleEvent("items.update"))
    action("items.delete", handleEvent("items.delete"))
}

export default hooks
