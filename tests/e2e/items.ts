import { ID } from "@directus/sdk"
import { client } from "./directus"
import { episodes as Types } from "./types"

export const createItem = async <C extends keyof Types>(collection: C, obj: Types[C]) => {
    return await client.items(collection).createOne(obj) as NonNullable<Types[C]>
}

export const deleteItem = async <C extends keyof Types>(collection: C, id: ID) => {
    await client.items(collection).deleteOne(id)
}

export class Factory<C extends keyof Types> {
    private items: Types[C][] = []

    constructor(private collection: C, private keyfunc: (i: Types[C]) => ID) {}

    public async create(obj: Types[C]) {
        const item = await client.items(this.collection).createOne(obj) as NonNullable<Types[C]>

        this.items.push(item)

        return item
    }

    public async get(id: ID) {
        return await client.items(this.collection).readOne(id) as NonNullable<Types[C]>
    }

    public async dispose() {
        await client.items(this.collection).deleteMany(this.items.map(i => this.keyfunc(i)))
    }

    public async delete(id: ID) {
        this.items = this.items.filter(i => this.keyfunc(i) === id)
        await client.items(this.collection).deleteOne(id)
    }
}

export const episodes = () => new Factory("episodes", i => i.id ?? 0)
