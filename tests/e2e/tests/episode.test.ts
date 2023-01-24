import test from "ava"
import { createItem, deleteItem } from "../items"
import { authed } from "../utils"

authed(test)

test("create episode", async t => {
    const episode = await createItem("episodes", {
        production_date: new Date().toISOString(),
        publish_date: new Date().toISOString(),
    })

    t.truthy(episode)

    await deleteItem("episodes", episode.id ?? 0)
})
