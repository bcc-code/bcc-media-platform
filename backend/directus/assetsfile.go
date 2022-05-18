package directus

// Assetfile item in the DB
type Assetfile struct {
	ID               int    `json:"id,omitempty"`
	Path             string `json:"path"`
	Storage          string `json:"storage"`
	Type             string `json:"type"`
	MimeType         string `json:"mime_type"`
	AssetID          int    `json:"asset_id"`
	ExtraMetadata    string `json:"extra_metadata,omitempty"`
	AudioLanguge     string `json:"audio_language"`
	SubtitleLanguage string `json:"subtitle_language"`
}

// UID returns the id of the Asset
func (a Assetfile) UID() int {
	return a.ID
}

// TypeName of the item. Statically set to "asset"
func (Assetfile) TypeName() string {
	return "assetfiles"
}
