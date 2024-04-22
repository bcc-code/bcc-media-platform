package common

const (
	TypeHLSCmaf = "hls_cmaf"
	TypeDash    = "dash"
)

var (
	// IgnoreEpisodeAssetEndpoint is here for ignoring a specific endpoint because it doesn't work.
	IgnoreEpisodeAssetEndpoints = []string{
		"7c011f242c6f4875a52e400061ef784a", // CMAF-SHORTS
		"942b3eed46ad4ec48e539fa12f81b50e", // CMAF-SHORTS-V2
	}
)
