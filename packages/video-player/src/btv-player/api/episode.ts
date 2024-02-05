import { ApiClient } from "./client"
import { gql, GraphQLClient } from "graphql-request"

export const getEpisodeStreams = async (
    episodeID: string,
    client?: ApiClient
) => {
    client ??= ApiClient.default
    const query = gql`
        query getEpisode($ID: ID!) {
            episode(id: $ID) {
                image
                streams {
                    audioLanguages
                    subtitleLanguages
                    url
                    type
                    videoLanguage
                }
            }
        }
    `

    const token = await client.getToken()

    const headers = {} as HeadersInit

    if (token) {
        headers["Authorization"] = "Bearer " + token
    }
    if (client.application) {
        headers["X-Application"] = client.application
    }

    const c = new GraphQLClient(client.endpoint, { headers })

    const response = await c.request<{
        episode: {
            image: string
            streams: {
                audioLanguages: string[]
                subtitleLanguages: string[]
                videoLanguage: string
                url: string
                type: "hls_cmaf" | "dash" | "hls_ts"
            }[]
        }
    }>(query, {
        ID: episodeID,
    })

    return response.episode
}
