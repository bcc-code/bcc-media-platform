import { faker } from "@faker-js/faker";
import { query } from "./api";
import { client } from "./directus";

export async function getApiResponsefromEpisodeWithStatus(status: string) {
    const episode = await client.items("episodes").createOne({
        status: status,
        production_date: new Date().toISOString(),
        publish_date: new Date().toISOString(),
        usergroups: [
            {
                usergroups_code: "public",
            },
        ],
        translations: [
            {
                languages_code: "no",
                title: status,
            },
        ],
    })

    const queryString =
        `
        query($episodeId: ID!) {
            episode(id: $episodeId) {
                title
            }
        }
        `;
    
    const apiResponse = await query(queryString, {
            episodeId: episode.id!,
        })

    return apiResponse
}

export async function getApiResponsefromEpisodeWithAvailability(title: string, available_from?: Date, available_to?: Date) {
    const episode = await client.items("episodes").createOne({
        status: "published",
        available_from: available_from == null ? null : available_from.toISOString(),
        available_to: available_to == null ? null : available_to.toISOString(),
        production_date: new Date().toISOString(),
        publish_date: available_from == null ? faker.date.future().toISOString() : available_from.toISOString(),
        usergroups: [
            {
                usergroups_code: "public",
            },
        ],
        translations: [
            {
                languages_code: "no",
                title: title,
            },
        ],
    })

    const queryString =
        `
        query($episodeId: ID!) {
            episode(id: $episodeId) {
                title
                availableFrom
                availableTo
            }
        }
        `;
    
    const apiResponse = await query(queryString, {
            episodeId: episode.id!,
        })

    return apiResponse
}