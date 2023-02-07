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

export async function createEpisodeWith(title: string, available_from?: Date, available_to?: Date, publish_date?: Date, asset_id?: number) {
    const episode = await client.items("episodes").createOne({
        status: "published",
        available_from: available_from?.toISOString() ?? null,
        available_to: available_to?.toISOString() ?? null,
        production_date: new Date().toISOString(),
        publish_date: publish_date?.toISOString() ?? available_from?.toISOString() ?? faker.date.future().toISOString(),
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
        asset_id: asset_id
    })

    return episode
}

export async function GetApiResonseforAvailability(id: number) {
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
        episodeId: id,
    })

    return apiResponse
}