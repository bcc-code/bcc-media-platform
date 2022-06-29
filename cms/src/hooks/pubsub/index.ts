import { handleEvent } from "./publish";

type Translation = "shows_translations" | "seasons_translations" | "episodes_translations"
type Object = "shows" | "seasons" | "episodes"
export type Collection = Translation | Object

export interface Event {
    key: number;
    keys: (number | string)[]
    payload: any;
    collection: Collection;
}

export interface HookObject {
    action: (event: string, action: (event: Event) => void) => void
}

export function enabled() {
    return process.env.PUBSUB_ENABLED === "true"
}

export default function ({ action }: HookObject) {
    if (!enabled())
        return

    action("items.create", handleEvent("items.create"))
    action("items.update", handleEvent("items.update"))
    action("items.delete", handleEvent("items.delete"))
}