// Pure NPAW config mapping, split from ../npaw.ts so tests don't pull in
// the 800 KB NPAW SDK + Hls.js side-effect imports just to exercise the
// mapping.

export interface NPAWOptions {
    enabled?: boolean
    accountCode?: string
    appName: string
    tracking: {
        isLive?: boolean
        userId?: string
        sessionId?: string
        ageGroup?: string
        metadata: {
            contentId?: string
            title?: string
            episodeTitle?: string
            seasonId?: string
            seasonTitle?: string
            showTitle?: string
            showId?: string
            overrides?: { [key: string]: string }
        }
    }
}

export function toConfig(options: NPAWOptions): Record<string, unknown> {
    const md = options.tracking.metadata
    return {
        "content.isLive": options.tracking.isLive === true,
        "content.id": md.contentId, // prefixed by E or P. Episode 385 = E385. Program 52 = P52
        "content.title": md.title,
        "content.program": md.showTitle ?? md.title,
        "content.tvShow": md.showId,
        "content.season": md.seasonId
            ? `${md.seasonId} - ${md.seasonTitle}`
            : undefined,
        "content.episodeTitle": md.episodeTitle,
        "user.obfuscateIp": true,
        "user.name": options.tracking.userId,
        "app.name": options.appName,
        "app.releaseVersion": "",
        "parse.manifest": true,
        "content.customDimension.1": options.tracking.sessionId,
        "content.customDimension.2": options.tracking.ageGroup,
        ...md.overrides,
    }
}
