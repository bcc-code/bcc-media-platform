import { faker } from "@faker-js/faker";
import test from "ava"
import { createEpisodeWith as createEpisodeWith, GetApiResonseforAvailability } from "lib/apiResponseFromEpisode";
import { ApiErrorCodes } from "lib/constants";
import { authed } from "lib/utils"

authed(test)

//Availability dates: to
//-----------------------------------------------

test("available to", async (t) => {
    let episode = await createEpisodeWith({ title: "available_to in future", availableFrom: null, availableTo: faker.date.future() })
    let apiResponse = await GetApiResonseforAvailability(episode.id);
    t.not(apiResponse.data.episode, null, "Episode that's available to future is not available");

    episode = await createEpisodeWith({ title: "available_to in past", availableFrom: null, availableTo: faker.date.past() })
    apiResponse = await GetApiResonseforAvailability(episode.id);
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode that's available to past is available")

    episode = await createEpisodeWith({ title: "available_to in null", availableFrom: null, availableTo: null })
    apiResponse = await GetApiResonseforAvailability(episode.id);
    t.not(apiResponse.data.episode, null, "Episode that's available to null is not available")
})
