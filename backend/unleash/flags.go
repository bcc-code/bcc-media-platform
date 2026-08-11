package unleash

// ShortsWithScoresFlag enables shorts sorting by scores
//
// Started: 20.9.2024
// To be Removed Latest: 20.12.2024
const ShortsWithScoresFlag = "shorts-with-scores3"
const ShortsWithScoresEnabledVariant = "enabled"

// DebugFlag exposes debug-only fields that are otherwise zeroed, currently
// Short.score.
const DebugFlag = "debug"

// ApplicationPageFlag overrides the root page an application opens on. Unlike
// the other flags its variant is not an enum but the page code to use.
const ApplicationPageFlag = "application-page"

// StreamProxyFlag toggles the URL signing path for stream manifests. The
// default is the stream-proxy + HS256 JWT path; the `legacy` variant opts a
// request back to the legacy CloudFront EncodedPolicy URLs (kept temporarily
// as an emergency rollback lever).
//
// Added: 05.05.2026
const StreamCDNProviderFlag = "cdn-provider"
const StreamCDNCloudfrontDirect = "cloudfront-direct"
const StreamCDNProxyCF = "cloudfront"
const StreamCDNProxyIORiver = "ioriver"

// LiveCDNProviderFlag is the livestream counterpart of StreamCDNProviderFlag,
// using the same variants, so live can be rolled out to (and rolled back from)
// the stream-proxy independently of VOD.
//
// Added: 27.07.2026
const LiveCDNProviderFlag = "live-cdn-provider"
