import { faker } from "@faker-js/faker";
import test from "ava"
import { getApiResponsefromEpisodeWithAvailability as getApiResponsefromEpisodeWithAvailability } from "lib/apiResponseFromEpisode";
import { ApiErrorCodes } from "lib/constants";
import { authed } from "lib/utils"

authed(test)

//Availability dates: both from and to
//-----------------------------------------------

test("check if available_from in future && available_to in the past: is not available", async(t) => {
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test7: Available_from in future and Available_to past", faker.date.future(), faker.date.past());
    t.is(apiResponse.errors[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode that's not available from future and to past");
})

test("check if available_from in future && available_to in the future: is not available", async(t) => {
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test8: Available_from in future and Available_to future", faker.date.future(), faker.date.future());
    t.is(apiResponse.errors[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode that's not available from future and to future");
})

test("check if available_from in the past && available_to in the past: is not available", async(t) => {
    const apiResponse = await getApiResponsefromEpisodeWithAvailability("Test9: Available_from in past and Available_to past", faker.date.past(), faker.date.past());
    t.is(apiResponse.errors[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode that's not available from past and to past");
})