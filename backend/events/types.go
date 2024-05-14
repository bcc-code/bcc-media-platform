package events

// AssetDelivered is the event originating from MEDIABANKEN notifying the system
// That an update for a VOD episode is available on the storage.
// Note that this may trigger a creation of a new Episode as required
type AssetDelivered struct {
	JSONMetaPath string `json:"jsonMetaPath"`
}

type AssetTimedMetadataDelivered struct {
	VXID     string `json:"vxID"`
	JSONPath string `json:"jsonPath"`
}

// RefreshView is an event requestig refresh of a view in the DB
// This is a generic event and the ViewName should be checked against a list of
// known views to prevent potential abuse
type RefreshView struct {
	ViewName string `json:"viewName"`
	Force    bool   `json:"force"`
}
