package events

// Collection of possible sources for events
const (
	SourceMediaBanken    = "mediabanken"
	SourceCloudScheduler = "cloudscheduler"
)

// Collection of possible event types
const (
	TypeAssetDelivered    = "asset.delivered"
	TypeRefreshView       = "view.refresh"
	TypeDirectusEvent     = "directus.event"
	TypeSearchReindex     = "search.reindex"
	TypeTranslationsSync  = "translations.sync"
	TypeExportAnswersToBQ = "statistics.exportanswers"
)
