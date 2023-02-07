import { faker } from "@faker-js/faker";
import test from "ava"
import { getApiResponsefromEpisodeWithAvailability as getApiResponsefromEpisodeWithAvailability } from "lib/apiResponseFromEpisode";
import { ApiErrorCodes } from "lib/constants";
import { authed } from "lib/utils"

authed(test)

//Availability dates: to
//-----------------------------------------------

test("check if available_to in future: is available", async(t) =>{
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test4 Available_to in future", null, faker.date.future()) 
    t.not(apiResponse.data.episode, null, "Episode that's available to future is available");
})

test("check if available_to in past: not available",async (t) => {
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test5 Available_to in past", null, faker.date.past())
    t.is(apiResponse.errors[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode that's available to past is not available")
})

test("check if available_to in null: is available", async(t) => {
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test6 Available_to in null", null, null)
    t.not(apiResponse.data.episode, null, "Episode that's available to null is available")
})