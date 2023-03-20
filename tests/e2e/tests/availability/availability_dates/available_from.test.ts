import { faker } from "@faker-js/faker";
import test from "ava"
import { createEpisodeWith as createEpisodeWith, GetApiResonseforAvailability } from "lib/apiResponseFromEpisode";
import { ApiErrorCodes } from "lib/constants";
import { authed } from "lib/utils"

authed(test)

//Availability dates: from
//-----------------------------------------------

test("available from", async (t) => {
    let episode = await createEpisodeWith({ title: "available_from in future", availableFrom: faker.date.future(), availableTo: null });
    let apiResponse = await GetApiResonseforAvailability(episode.id);
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode that's available from the future dosen't get the right error code");

    episode = await createEpisodeWith({ title: "available_from in past", availableFrom: faker.date.past(), availableTo: null });
    apiResponse = await GetApiResonseforAvailability(episode.id);
    t.not(apiResponse.data.episode, null, "Episode that's available from the past is not available");

    episode = await createEpisodeWith({ title: "available_from null", availableFrom: null, availableTo: null });
    apiResponse = await GetApiResonseforAvailability(episode.id);
    t.not(apiResponse.data.episode, null, "Episode that's available from null is not available")
})