package directus

// AssetFile item in the DB
type AssetFile struct {
	ID               int    `json:"id,omitempty"`
	Path             string `json:"path"`
	Storage          string `json:"storage"`
	Type             string `json:"type"`
	MimeType         string `json:"mime_type"`
	AssetID          int    `json:"asset_id"`
	ExtraMetadata    string `json:"extra_metadata,omitempty"`
	AudioLanguage    string `json:"audio_language"`
	SubtitleLanguage string `json:"subtitle_language"`
}

// UID returns the id of the Asset
func (a AssetFile) UID() int {
	return a.ID
}

// TypeName of the item. Statically set to "asset"
func (AssetFile) TypeName() string {
	return "assetfiles"
}

// ForUpdate prepares a copy of the struct for Directus update op
func (a AssetFile) ForUpdate() interface{} {
	return a
}
