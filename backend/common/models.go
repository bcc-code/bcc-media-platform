package common

type SearchQuery struct {
	Query string `json:"query"`
	Page  int    `json:"page"`
}

type SearchResult struct {
	ResultCount int                `json:"resultCount"`
	Result      []SearchResultItem `json:"result"`
	HitCount    int                `json:"hitCount"`
	Page        int                `json:"page"`
	PageCount   int                `json:"pageCount"`
}

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

type Translation struct {
	Language    string
	Title       string
	Description string
	// Details. Usually technical
	Details string
}
