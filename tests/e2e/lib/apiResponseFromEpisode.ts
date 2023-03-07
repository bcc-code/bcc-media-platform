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

export async function createEpisodeWith(args: { title: string, availableFrom?: Date, availableTo?: Date, publishDate?: Date, assetId?: number }) {
    const episode = await client.items("episodes").createOne({
        status: "published",
        available_from: args.availableFrom?.toISOString() ?? null,
        available_to: args.availableTo?.toISOString() ?? null,
        production_date: new Date().toISOString(),
        publish_date: args.publishDate?.toISOString() ?? args.availableFrom?.toISOString() ?? faker.date.future().toISOString(),
        usergroups: [
            {
                usergroups_code: "public",
            },
        ],
        translations: [
            {
                languages_code: "no",
                title: args.title,
            },
        ],
        asset_id: args.assetId
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