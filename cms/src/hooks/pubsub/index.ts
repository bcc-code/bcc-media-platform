import { handleEvent } from "./publish";
import { HookConfig } from "@directus/shared/src/types"

type Translation = "shows_translations" | "seasons_translations" | "episodes_translations"
type Object = "shows" | "seasons" | "episodes"
type Singleton = "globalconfig" | "appconfig" | "webconfig" | "maintenancemessage"
export type Collection = Translation | Object | Singleton

export interface Event {
    key: number;
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