package directus

import "net/url"

// Asset item in the DB
type Asset struct {
	ID              int    `json:"id,omitempty"`
	Name            string `json:"name"`
	Duration        int    `json:"duration"`
	MediabankenID   string `json:"mediabanken_id"`
	EncodingVersion string `json:"encoding_version"`
	MainStoragePath string `json:"main_storage_path"`
}

// UID returns the id of the Asset
func (a Asset) UID() int {
	return a.ID
}

// TypeName of the item. Statically set to "asset"
func (Asset) TypeName() string {
	return "assets"
}

// FindNewestAssetByMediabankenID in directus
func FindNewestAssetByMediabankenID(mediabankenID string) error {

	// q, err := url.Parse(`http://localhost:8055/items/assets?limit=25&fields[]=duration&fields[]=encoding_version&fields[]=mediabanken_id&fields[]=name&fields[]=id&sort[]=id&page=1&filter={"_and":[{"mediabanken_id":{"_eq":"AS-VX-13"}}]}&meta[]=filter_count&meta[]=total_count`)

	q := url.URL{}
	q.Path = "items/assets"

	// Just the newest one
	q.Query().Add("limit", "1")
	q.Query().Add("page", "1")
	q.Query().Add("sort", "-date_created")

	q.Query().Add("fields[]", "id")
	q.Query().Add("fields[]", "base_path")
	q.Query().Add("fields[]", "files.path")
	q.Query().Add("fields[]", "streams.*")
	return nil
}
