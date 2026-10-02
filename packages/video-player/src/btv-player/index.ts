import { getEpisodeStreams } from "./api"
import { ApiClient, ApiClientOptions } from "./api/client"
import { createPlayer, Options } from "../video-player"
import { toVideoLanguageOptions } from "./streams"
export * from "./api"
export * from "./streams"

export class PlayerFactory {
    private client: ApiClient

    constructor(options: ApiClientOptions) {
        this.client = new ApiClient(options)
    }

    public async create(
        elementId: string,
        options: {
            episodeId: string
            overrides?: Partial<Options>
            /** Which video language to start on — the language of text burned
             *  into the picture, or a sign-language version. Omit for the
             *  original. The viewer can switch from the settings menu when the
             *  episode has more than one. */
            videoLanguage?: string
        }
    ) {
        const episode = await getEpisodeStreams(options.episodeId, this.client)

        const videoLanguages = toVideoLanguageOptions(episode.streams)
        if (!videoLanguages.length) return null

        const merged: Partial<Options> = {
            videojs: { poster: episode.image },
            chapters: episode.chapters,
            ...options.overrides,
            // After the spread: an episode's renditions are not something a
            // caller's `overrides` should be able to contradict.
            videoLanguages,
            videoLanguage: options.videoLanguage ?? null,
        }
        return await createPlayer(elementId, merged)
    }
}
