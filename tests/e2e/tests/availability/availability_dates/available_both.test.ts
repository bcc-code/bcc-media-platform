import { faker } from "@faker-js/faker";
import test from "ava"
import { createEpisodeWith as createEpisodeWith, GetApiResonseforAvailability } from "lib/apiResponseFromEpisode";
import { ApiErrorCodes } from "lib/constants";
import { authed } from "lib/utils"

authed(test)

//Availability dates: both from and to
//-----------------------------------------------

test("available from and to", async (t) => {

    let episode = await createEpisodeWith({ title: "available_from in future and available_to past", availableFrom: faker.date.future(), availableTo: faker.date.past() });
    let apiResponse = await GetApiResonseforAvailability(episode.id);
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode available from future and to past dosen't get the right error code");

    episode = await createEpisodeWith({ title: "available_from in future and available_to future", availableFrom: faker.date.future(), availableTo: faker.date.future(10) });
    apiResponse = await GetApiResonseforAvailability(episode.id);
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode available from future and to future dosen't get the right error code");

    episode = await createEpisodeWith({ title: "available_from in past and available_to past", availableFrom: faker.date.past(), availableTo: faker.date.past() });
    apiResponse = await GetApiResonseforAvailability(episode.id);
    t.is(apiResponse.errors?.[0].extensions.code, ApiErrorCodes.ItemNotPublished, "Episode available from past and to past dosen't get the right error code");
})
