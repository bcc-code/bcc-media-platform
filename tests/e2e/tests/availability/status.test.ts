import test from "ava"
import { authed } from "lib/utils"
import { ApiErrorCodes } from "lib/constants"
import { getApiResponsefromEpisodeWithStatus } from "lib/apiResponseFromEpisode"

authed(test)

//Status tests
//-----------------------------------------------

test("Status", async (t) => {
    let apiResponse = await getApiResponsefromEpisodeWithStatus("published");
    t.not(apiResponse.data.episode, null, "the episode (status: published) is null");

    apiResponse = await getApiResponsefromEpisodeWithStatus("draft");
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNotPublished, "the episode (status: draft) dosen't get the right error code");

    apiResponse = await getApiResponsefromEpisodeWithStatus("archived");
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNotPublished, "the episode (status: archived) dosen't get the right error code");

    apiResponse = await getApiResponsefromEpisodeWithStatus("NonexistantStatus");
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNotPublished, "the episode with wrong status dosen't get error code");
})
