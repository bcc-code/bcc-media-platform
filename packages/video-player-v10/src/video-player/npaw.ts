import type { Player } from "./index"

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

// NPAW v10 adapter does not exist as of @videojs/core@10.0.0-beta.23.
// Keeping the public type and function shape so consumers compile;
// analytics will be wired once vendor (or hand-rolled) v10 adapter lands.
// See V10_MIGRATION.md, blocker #1.

export function enableNPAW(_player: Player, _options: NPAWOptions): void {}

export function setOptions(_player: Player, _options: NPAWOptions): void {}
