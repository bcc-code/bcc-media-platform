import { getEpisodeStreams } from "./api"
import { ApiClient, ApiClientOptions } from "./api/client"
import { createPlayer, Options } from "../video-player"
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
        videoLanguage?: string
    }) {
        const episode = await getEpisodeStreams(options.episodeId, this.client)

        const streams = episode.streams

        const videoLanguage = options.videoLanguage

        if (streams.length) {
            const langCheck = (stream: typeof streams[0]) => {
                if (videoLanguage) {
                    return stream.videoLanguage === videoLanguage
                }
                return true;
            }
            let stream = streams.find(s => s.type === "hls_cmaf" && langCheck(s))
            if (!stream) {
                stream = streams.find(s => s.type === "hls_ts" && langCheck(s))
            }
            if (!stream) {
                stream = streams.find(s => s.type === "dash" && langCheck(s))
            }
            if (!stream) {
                stream = streams.find(s => s.type === "hls_cmaf")
            }
            if (stream) {
                return await createPlayer(elementId, videojs.mergeOptions(
                    {
                        src: {
                            src: stream.url,
                        },
                        videojs: {
                            poster: episode.image
                        }
                    } as Partial<Options>,
                    options.overrides
                ))
            }
        }

        return null
    }
}
