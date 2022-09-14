import { ApiClient } from "./client";
import { gql, GraphQLClient } from "graphql-request"

export const getEpisodeStreams = async (episodeID: string, client?: ApiClient) => {
    client ??= ApiClient.default
    const query = gql`
    query getEpisode($ID: ID!) {
        episode(id: $ID) {
            imageUrl
            streams {
                audioLanguages
                subtitleLanguages
                url
                type
            }
        }
    }`

    const token = await client.getToken()

    const headers = {} as HeadersInit

    if (token) {
        headers["Authorization"] = "Bearer " + token
    }

    const c = new GraphQLClient(client.endpoint, {headers})

    const response = await c.request(query, {
        ID: episodeID,
    })

    return response.episode as {
        imageUrl: string;
        streams: {
            audioLanguages: string[];
            subtitleLanguages: string[];
            url: string;
            type: "hls_cmaf" | "dash" | "hls_ts";
        }[]
    };
}
