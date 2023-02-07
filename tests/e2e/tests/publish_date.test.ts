import { faker } from "@faker-js/faker";
import test from "ava"
import { query } from "lib/api";
import { createEpisodeWith as createEpisodeWith } from "lib/apiResponseFromEpisode";
import { ApiErrorCodes } from "lib/constants";
import { client } from "lib/directus";
import { authed } from "lib/utils"

authed(test)

//Publish date tests
//-----------------------------------------------



test("Publish Date", async (t) => {
    const asset = await client.items("assets").createOne({
        status: "published",
        name: faker.vehicle.type(),
        duration: 500,
        streams: [{ type: "hls-cmaf", url: "https://tests.bcc.media/index.m3u8", service: "mediapackage", path: "/" }]
    })

    const queryString =
        `
        query($episodeId: ID!) {
            episode(id: $episodeId) {
                title
                availableFrom
                availableTo
                imageUrl
                streams {
                    url
                }
            }
        }
        `;

    //-----------------------------------------------

    let episode = await createEpisodeWith("PublishDate Test1", null, null, faker.date.future(), asset.id);
    let apiResponse = await query(queryString, {
        episodeId: episode.id!,
    })
    let streams = apiResponse.data.episode.streams as any[];
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNoAccess, "episode.streams[] dosen't get error or streams[] exists");

    //-----------------------------------------------

    episode = await createEpisodeWith("PublishDate Test2", null, null, faker.date.past(), asset.id);
    apiResponse = await query(queryString, {
        episodeId: episode.id!,
    })
    streams = apiResponse.data?.episode.streams as any[];
    t.truthy(streams, "episode.streams[] dosen't exist. errors: " + JSON.stringify(apiResponse.errors));

    //-----------------------------------------------

    episode = await createEpisodeWith("PublishDate Test3", null, null, faker.date.future(), asset.id);
    apiResponse = await query(queryString, {
        episodeId: episode.id!,
    })
    t.truthy(apiResponse.data.episode.title, "episode.title can't be retrieved");
    // check errors is
    t.falsy(apiResponse.errors, "There were errors");
})