package directus

import "strconv"

// Stream types
const (
	HLSCmaf = "hls_cmaf"
	HLSTs   = "hls_ts"
	Dash    = "dash"
)

// AssetStream item in the DB
type AssetStream struct {
	ID                int                             `json:"id,omitempty"`
	Status            string                          `json:"status,omitempty"`
	Type              string                          `json:"type"`
	URL               string                          `json:"url"`
	Path              string                          `json:"path"`
	Service           string                          `json:"service"`
	AudioLanguages    CRUDArrays[AssetStreamLanguage] `json:"audio_languages"`
	SubtitleLanguages CRUDArrays[AssetStreamLanguage] `json:"subtitle_languages"`
	AssetID           int                             `json:"asset_id"`
}

// AssetStreamLanguage is a wrapper for linking AssetStream and LanguagesCode
type AssetStreamLanguage struct {
	AssetStreamID string        `json:"assetstreams_id"`
	LanguagesCode LanguagesCode `json:"languages_code"`
}

// UID returns the id of the Asset
func (a AssetStream) UID() string {
	if a.ID == 0 {
		return ""
	}
	return strconv.Itoa(a.ID)
}

// TypeName of the item. Statically set to "assetstreams"
func (AssetStream) TypeName() string {
	return "assetstreams"
}

// ForUpdate prepares a copy of the struct for Directus update op
func (a AssetStream) ForUpdate() interface{} {
	return a
}
