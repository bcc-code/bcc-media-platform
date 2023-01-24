import { ID } from "@directus/sdk"
import { client } from "./client"
import { episodes } from "./types"

export const createItem = async <C extends keyof episodes>(collection: C, obj: episodes[C]) => {
    return await client.items(collection).createOne(obj)
}

export const deleteItem = async <C extends keyof episodes>(collection: C, id: ID) => {
    await client.items(collection).deleteOne(id)
}
