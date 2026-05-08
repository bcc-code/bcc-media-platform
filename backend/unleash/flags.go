package unleash

// ShortsWithScoresFlag enables shorts sorting by scores
//
// Started: 20.9.2024
// To be Removed Latest: 20.12.2024
const ShortsWithScoresFlag = "shorts-with-scores3"
const ShortsWithScoresEnabledVariant = "enabled"

// ElasticSearchFlag enables the elastic search for the client
//
// Added: 07.10.2024
const ElasticSearchFlag = "elastic-search"
const ElasticSearchEnabledVariant = "enabled"

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
