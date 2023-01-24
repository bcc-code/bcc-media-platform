import test from "ava"
import { episodes } from "../items"
import { authed } from "../utils"
import { query } from "../api"

authed(test)

test("create and delete episode", async (t) => {
    const factory = episodes()
    const title = "EPISODE"

    try {
        const episode = await factory.create({
            status: "published",
            production_date: new Date().toISOString(),
            publish_date: new Date().toISOString(),
            usergroups: [
                {
                    usergroups_code: "public",
                },
            ],
            translations: [
                {
                    languages_code: "no",
                    title,
                },
            ],
        })

        t.truthy(episode, "episode is not null")

        const existing = await factory.get(episode.id ?? 0)

        t.truthy(existing, "episode exists")

        const queryString =
            "query($episodeId: ID!){ episode(id: $episodeId) { title }}"

        const apiResponse = await query(queryString, {
            episodeId: episode.id!,
        })

        t.is(title, apiResponse.data.episode.title, "titles not equal")
    } finally {
        await factory.dispose()
    }
})
