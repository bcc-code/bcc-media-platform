// Token sniffing is enough for the one thing this gates (the dismiss-controls
// button) and avoids a ~30 KB ua-parser-js dependency.
const SMART_TV_RE =
    /smart-?tv|tizen|web[o0]s|hbbtv|netcast|googletv|appletv|crkey/i

export const isSmartTV = (): boolean => {
    if (typeof navigator === "undefined") return false
    return SMART_TV_RE.test(navigator.userAgent)
}
