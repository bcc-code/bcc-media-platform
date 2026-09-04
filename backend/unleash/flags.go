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

// StreamCDNProviderFlag picks which upstream CDN identity the stream-proxy
// signs VOD requests for, carried as the JWT `provider` claim. Without the
// flag (or with an unknown variant) the signer default applies
// (streamtoken.DefaultPrimaryProvider = ioriver); the `cloudfront` variant
// routes a request through the proxy's direct-CloudFront identity instead.
//
// Added: 05.05.2026
const StreamCDNProviderFlag = "cdn-provider"
const StreamCDNProxyCF = "cloudfront"
const StreamCDNProxyIORiver = "ioriver"

// LiveCDNProviderFlag is the livestream counterpart of StreamCDNProviderFlag,
// using the same variants, so live's upstream identity can be switched
// independently of VOD.
//
// Added: 27.07.2026
const LiveCDNProviderFlag = "live-cdn-provider"
