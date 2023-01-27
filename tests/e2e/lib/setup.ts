import { createItem } from "./items"
import { randomUUID } from "crypto"
import { episodes } from "./types"


export async function createApp(data?: episodes["applications"]) {
    const id = randomUUID();
    const defaults = {
        name: id,
        code: id,
    } as episodes["applications"]

    return await createItem("applications", Object.assign(defaults, data))
}

export async function createRole(data?: episodes["usergroups"]) {
    const id = randomUUID();
    const defaults = {
        name: id,
        code: id,
    } as episodes["usergroups"]

    return await createItem("usergroups", Object.assign(defaults, data))
}