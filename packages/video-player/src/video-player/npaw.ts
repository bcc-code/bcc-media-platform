import { VideoJsPlayer } from "video.js"
import lib from "youboralib"
import Adapter from "youbora-adapter-videojs"

export type Options = {
    enabled?: boolean,
    accountCode?: string,
    tracking: {
        isLive?: boolean,
        userId?: string,
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
            overrides?: { [key: string]: string }
        },
    }
}

function toConfig(options: Options) {
    const md = options.tracking.metadata
    return {
        "content.isLive": options.tracking.isLive === true,
        "content.id": md.contentId, // prefixed by E or P. Episode 385 = E385. Program 52 = P52
        "content.title": md.title,
        "content.program": md.showTitle ?? md.title,
        "content.tvShow": md.showId,
        "content.season": md.seasonId ? `${md.seasonId} - ${md.seasonTitle}` : undefined,
        "content.episodeTitle": md.episodeTitle,
        obfuscateIp: true,
        "user.name": options.tracking.userId,
        "app.name": "web",
        "app.releaseVersion": "",//RELEASE_VERSION,
        "parse.manifest": true,
        "extraparam.1": options.tracking.sessionId,
        "extraparam.2": options.tracking.ageGroup,
        ...md.overrides
    }
}

export function enableNPAW(player: VideoJsPlayer, options: Options) {
    if (!options.accountCode) {
        console.warn(
            "NPAW was not enabled because options.npaw.accountCode is invalid."
        )
        return
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
