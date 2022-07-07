package common

import "gopkg.in/guregu/null.v4"

// SearchQuery used as body in the POST request to the API
type SearchQuery struct {
	Query string `json:"query"`
	Page  int    `json:"page"`
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
	Model       string  `json:"model"`
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

// Translation struct for storing a generalized translation object
type Translation struct {
	Language    string
	Title       null.String
	Description null.String
	// Details. Usually technical
	Details null.String
}
