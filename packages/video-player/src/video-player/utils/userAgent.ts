// Smart-TV browsers identify themselves with a few well-known tokens in the
// UA string. Sufficient for our needs (showing a dismiss-controls button)
// and avoids pulling in ua-parser-js (~30 KB) just for this single check.
//
// Test UA: "Mozilla/5.0 (SMART-TV; Linux; Tizen 2.3) ... SamsungBrowser/1.0 TV"
const SMART_TV_RE = /smart-?tv|tizen|web[o0]s|hbbtv|netcast|googletv|appletv|crkey/i

export const isSmartTV = (): boolean => {
    if (typeof navigator === "undefined") return false
    return SMART_TV_RE.test(navigator.userAgent)
}
