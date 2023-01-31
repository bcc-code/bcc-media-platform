import test from "ava"
import { authed } from "lib/utils"
import { query } from "lib/api"
import { client } from "lib/directus"

authed(test)

test("create episode", async (t) => {
    const title = "Kåre Smith the Movie"

    const episode = await client.items("episodes").createOne({
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

    //check if episode ain't null
    t.truthy(episode, "episode is not null")

    //read the newly added episode into a variable
    const existing = await client.items("episodes").readOne(episode.id)

    //check if the episode does exist
    t.truthy(existing, "episode exists")

    const queryString =
        `
        query($episodeId: ID!) {
            episode(id: $episodeId) {
                title
                
            }
        }
        `;

    const apiResponse = await query(queryString, {
        episodeId: episode.id!,
    })

    t.is(title, apiResponse.data.episode.title, "titles not equal")
})
