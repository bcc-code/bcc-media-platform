// Pure localStorage helpers for hls.js's ABR bandwidth seed. Split from
// ../index.ts so tests don't pull in custom-element registrations.

export const BW_STORAGE_KEY = "bccm-video-player.bandwidth-estimate"
export const BW_WRITE_THROTTLE_MS = 10_000

export function readSavedBandwidth(): number | null {
    try {
        const raw = localStorage.getItem(BW_STORAGE_KEY)
        if (!raw) return null
        const value = Number(raw)
        return Number.isFinite(value) && value > 0 ? value : null
    } catch {
        // localStorage unavailable (private mode, blocked, SSR).
        return null
    }
}

export function writeSavedBandwidth(value: number): void {
    if (!Number.isFinite(value) || value <= 0) return
    try {
        localStorage.setItem(BW_STORAGE_KEY, String(Math.round(value)))
    } catch {
        // ignore — best-effort persistence
    }
}
