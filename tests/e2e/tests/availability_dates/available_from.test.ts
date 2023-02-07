import { faker } from "@faker-js/faker";
import test from "ava"
import { getApiResponsefromEpisodeWithAvailability as getApiResponsefromEpisodeWithAvailability } from "lib/apiResponseFromEpisode";
import { ApiErrorCodes } from "lib/constants";
import { authed } from "lib/utils"

authed(test)

//Availability dates: from
//-----------------------------------------------

test("check if available_from in future: not available", async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test1: Available_from in future", faker.date.future(), null);
    t.is(apiResponse.errors[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode that's available from the future gets the right error code");
})

test("check if available_from in the past: is available", async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test2 Available_from in past", faker.date.future(), null);
    t.not(apiResponse.data.episode, null, "Episode that's available from the past is available");
})

test("check if available_from null: is available", async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test3 Available_from null", null, null);
    t.not(apiResponse.data.episode, null, "Episode that's available from null is available")
})