package directus

// Stream types
const (
	HLSCmaf = "hls-cmaf"
	HLSTs   = "hls-ts"
	Dash    = "dash"
)

// AssetStream item in the DB
type AssetStream struct {
	ID                int                            `json:"id,omitempty"`
	Status            string                         `json:"status,omitempty"`
	Type              string                         `json:"type"`
	URL               string                         `json:"url"`
	Path              string                         `json:"path"`
	Service           string                         `json:"service"`
	AudioLanguges     CRUDArrays[AssetStreamLanguge] `json:"audio_languages"`
	SubtitleLanguages CRUDArrays[AssetStreamLanguge] `json:"subtitle_languages"`
	AssetID           int                            `json:"asset_id"`
}

// AssetStreamLanguge is a wrapper for linking AssetStream and LanguagesCode
type AssetStreamLanguge struct {
	AssetStreamID string        `json:"assetstreams_id"`
	LanguagesCode LanguagesCode `json:"languages_code"`
}

// UID returns the id of the Asset
func (a AssetStream) UID() int {
	return a.ID
}

// TypeName of the item. Statically set to "asset"
func (AssetStream) TypeName() string {
	return "assetstreams"
}
