import { VideoJsPlayer } from "video.js"
import youboralib from "youboralib"
import youboraVideoJsAdapter from "youbora-adapter-videojs"

export type Options = {
    enabled?: boolean,
    accountCode?: string,
    tracking: {
        isLive: boolean,
        userId: string,
        metadata: {
            contentId?: number,
            title?: string,
            episodeTitle?: string,
            seasonTitle?: string,
            showTitle?: string,
        },
    }
}

export function enableNPAW(player: VideoJsPlayer, options: Options) {
    if (!options.accountCode) {
        console.warn(
            "NPAW was not enabled because options.npaw.accountCode is invalid. The value was: " +
                options.accountCode
        )
    }
    const npaw = new youboralib.Plugin({ accountCode: options.accountCode })
    const defaults = {
        "content.isLive": options.tracking.isLive === true,
        "content.id": options.tracking.metadata.contentId, // prefixed by E or P. Episode 385 = E385. Program 52 = P52
        "content.title": options.tracking.metadata.title,
        "content.program": options.tracking.metadata.showTitle ?? options.tracking.metadata.title,
        "content.tvShow": options.tracking.metadata.showTitle,
        "content.season": options.tracking.metadata.seasonTitle,
        "content.episodeTitle": options.tracking.metadata.episodeTitle,
        obfuscateIp: true,
        "user.name": options.tracking.userId,
        "app.name": "web",
        "app.releaseVersion": "",//RELEASE_VERSION,
        "parse.manifest": true,
    }
    npaw.setOptions(defaults)
    npaw.setAdapter(new youboraVideoJsAdapter(player)) // Attach adapter
}