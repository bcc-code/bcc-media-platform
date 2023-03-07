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
        streams: [{ type: "hls_cmaf", url: "https://tests.bcc.media/index.m3u8", service: "mediapackage", path: "/" }]
    })

    const queryString =
        `
        query($episodeId: ID!) {
            episode(id: $episodeId) {
                title
                availableFrom
                availableTo
                description
                streams {
                    url
                }
            }
        }
        `;

    //-----------------------------------------------

    let episode = await createEpisodeWith({ title: "publishDate future", availableFrom: null, availableTo: null, publishDate: faker.date.future(10), assetId: asset.id });
    let apiResponse = await query(queryString, {
        episodeId: episode.id!,
    })
    let streams = apiResponse.data?.episode.streams as any[];
    t.truthy(apiResponse.data.episode.title, "episode.title can't be retrieved");
    t.is(streams.length, 0, "episode.streams[] is not empty");

    //-----------------------------------------------

    episode = await createEpisodeWith({ title: "publishDate past", availableFrom: null, availableTo: null, publishDate: faker.date.past(), assetId: asset.id });
    apiResponse = await query(queryString, {
        episodeId: episode.id!,
    })
    streams = apiResponse.data?.episode.streams as any[];
    t.true(streams.length > 0, "episode.streams[] dosen't exist. errors: " + JSON.stringify(apiResponse.errors));

})