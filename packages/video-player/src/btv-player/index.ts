import { getEpisodeStreams } from "./api"
import { ApiClient, ApiClientOptions } from "./api/client"
import { createPlayer, Options } from "@/video-player"
import videojs from "video.js"
export * from "./api"


export class PlayerFactory {
    private client: ApiClient

    constructor(options: ApiClientOptions) {
        this.client = new ApiClient(options)
    }

    public async create(elementId: string, options: {
        episodeId: string,
        overrides?: Partial<Options>,
    }) {
        const episode = await getEpisodeStreams(options.episodeId, this.client)

        const streams = episode.streams

        if (streams.length) {
            let stream = streams.find(s => s.type === "hls_cmaf")
            if (!stream) {
                stream = streams.find(s => s.type === "hls_ts")
            }
            if (!stream) {
                stream = streams.find(s => s.type === "dash")
            }
            if (stream) {
                return await createPlayer(elementId, videojs.mergeOptions(
                    {
                        src: {
                            src: stream.url,
                        },
                        videojs: {
                            poster: episode.imageUrl
                        }
                    } as Partial<Options>,
                    options.overrides
                ))
            }
        }

        return null
    }
}
