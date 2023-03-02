import { VideoJsPlayer } from "video.js"
import lib from "youboralib"
import Adapter from "youbora-adapter-videojs"

export type Options = {
    enabled?: boolean,
    accountCode?: string,
    tracking: {
        isLive: boolean,
        userId: string,
        sessionId?: string,
        ageGroup?: string,
        metadata: {
            contentId?: string,
            title?: string,
            episodeTitle?: string,
            seasonId?: string,
            seasonTitle?: string,
            showTitle?: string,
            showId?: string,
        },
    }
}

function toConfig(options: Options) {
    return {
        "content.isLive": options.tracking.isLive === true,
        "content.id": options.tracking.metadata.contentId, // prefixed by E or P. Episode 385 = E385. Program 52 = P52
        "content.title": options.tracking.metadata.title,
        "content.program": options.tracking.metadata.showTitle ?? options.tracking.metadata.title,
        "content.tvShow": options.tracking.metadata.showId,
        "content.season": options.tracking.metadata.seasonId ? `${options.tracking.metadata.seasonId} - ${options.tracking.metadata.seasonTitle}` : undefined,
        "content.episodeTitle": options.tracking.metadata.episodeTitle,
        obfuscateIp: true,
        "user.name": options.tracking.userId,
        "app.name": "web",
        "app.releaseVersion": "",//RELEASE_VERSION,
        "parse.manifest": true,
        "extraparam.1": options.tracking.sessionId,
        "extraparam.2": options.tracking.ageGroup,
    }
}

export function enableNPAW(player: VideoJsPlayer, options: Options): typeof lib.Plugin {
    if (!options.accountCode) {
        console.warn(
            "NPAW was not enabled because options.npaw.accountCode is invalid."
        )
    }
    const npaw = new lib.Plugin({ accountCode: options.accountCode })

    const defaults = toConfig(options)

    npaw.setOptions(defaults)
    npaw.setAdapter(new Adapter(player)) // Attach adapter

    ;(player as any)._npaw = npaw
}

export function setOptions(player: VideoJsPlayer, options: Options) {
    const npaw = (player as any)._npaw;
    if (!npaw) {
        return
    }

    Object.assign(npaw.options, toConfig(options))
}
