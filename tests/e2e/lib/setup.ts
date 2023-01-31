import { randomUUID } from "crypto"
import { episodes } from "./types"
import { client } from "./directus"

export async function createApp(data?: episodes["applications"]) {
    const id = randomUUID()
    const defaults = {
        name: id,
        code: id,
    } as episodes["applications"]

    return (await client
        .items("applications")
        .createOne(Object.assign(defaults, data))) as NonNullable<
        episodes["applications"]
    >
}

export async function createRole(data?: episodes["usergroups"]) {
    const id = randomUUID()
    const defaults = {
        name: id,
        code: id,
    } as episodes["usergroups"]

    return (await client
        .items("usergroups")
        .createOne(Object.assign(defaults, data))) as NonNullable<
        episodes["usergroups"]
    >
}
