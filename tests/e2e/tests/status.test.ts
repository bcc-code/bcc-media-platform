import test from "ava"
import { authed } from "lib/utils"
import { ApiErrorCodes } from "lib/constants"
import { getApiResponsefromEpisodeWithStatus } from "lib/apiResponseFromEpisode"

authed(test)

//Status tests
//-----------------------------------------------

test("check if episode with status 'published': is available ", async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithStatus("published");

    t.not(apiResponse.data.episode, null, "the episode (status: published) is not null");
})

test("check if episode with status 'unlisted': is available", async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithStatus("unlisted");
    
    t.not(apiResponse.data.episode, null, "the episode (status: unlisted) is not null");
})

test("check if episode with status 'draft': is not available", async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithStatus("draft");

    t.is(apiResponse.errors[0].extensions.code, ApiErrorCodes.ItemNotPublished, "the episode (status: draft) gets the right error code");
})

test("check if episode with status 'archived': is not available", async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithStatus("archived");

    t.is(apiResponse.errors[0].extensions.code, ApiErrorCodes.ItemNotPublished, "the episode (status: archived) gets the right error code");
})

test("make sure episode with status that dosen't exist does return null", async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithStatus("NonexistantStatus");

    t.is(apiResponse.errors[0].extensions.code, ApiErrorCodes.ItemNotPublished, "the episode with wrong status gets the right error code");
})