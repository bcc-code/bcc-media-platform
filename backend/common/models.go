package common

import (
	"gopkg.in/guregu/null.v4"
	"time"
)

// SearchQuery used as body in the POST request to the API
type SearchQuery struct {
	Query    string  `json:"query"`
	Limit    *int    `json:"limit"`
	Offset   *int    `json:"offset"`
	Type     *string `json:"type"`
	MinScore *int    `json:"minScore"`
}

// SearchResult for exposing a list of search results
type SearchResult struct {
	ResultCount int                `json:"resultCount"`
	Result      []SearchResultItem `json:"result"`
	HitCount    int                `json:"hitCount"`
	Page        int                `json:"page"`
	PageCount   int                `json:"pageCount"`
}

// SearchResultItem for exposing search results through the API
type SearchResultItem struct {
	ID          int     `json:"id"`
	LegacyID    *int    `json:"legacyID"`
	Duration    *int    `json:"duration"`
	AgeRating   *string `json:"ageRating"`
	Collection  string  `json:"collection"`
	Title       string  `json:"title"`
	Header      *string `json:"header"`
	Description *string `json:"description"`
	ShowID      *int    `json:"showId,omitempty"`
	Show        *string `json:"show,omitempty"`
	SeasonID    *int    `json:"seasonId,omitempty"`
	Season      *string `json:"season,omitempty"`
	Highlight   *string `json:"highlight"`
	Image       *string `json:"thumbnail"`
	Url         string  `json:"url"`
}

// Roles struct for roles on item
type Roles struct {
	Access      []string
	Download    []string
	EarlyAccess []string
}

// Availability struct for availability on items
type Availability struct {
	Published bool
	From      time.Time
	To        time.Time
}

// MaintenanceMessage is the struct for maintenance messages
type MaintenanceMessage struct {
	Message LocaleString
	Details LocaleString
}

// AppConfig contains configuration of the app.
type AppConfig struct {
	MinVersion string
}

// GlobalConfig contains configuration of all clients
type GlobalConfig struct {
	LiveOnline  bool
	NPAWEnabled bool
}

// Notification contains notification data
type Notification struct {
	ID          int
	Status      Status
	Title       LocaleString           `json:"title"`
	Description LocaleString           `json:"description"`
	Images      LocaleMap[null.String] `json:"images"`
}

// Progress contains basic data for progress
type Progress struct {
	EpisodeID int
	Progress  time.Time
}

// GetKey returns the key for this item
func (i Progress) GetKey() int {
	return i.EpisodeID
}
