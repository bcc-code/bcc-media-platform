package base

type SearchQuery struct {
	Query string `json:"query"`
	Page  int    `json:"page"`
	//TODO: replace this (only for testing)
	Roles []string `json:"roles"`
}

type SearchResult struct {
	Result      []SearchResultItem `json:"result"`
	ResultCount int                `json:"resultCount"`
	HitCount    int                `json:"hitCount"`
	Page        int                `json:"page"`
	PageCount   int                `json:"pageCount"`
}

type SearchResultItem struct {
	Id          int     `json:"id"`
	Model       string  `json:"model"`
	Title       string  `json:"title"`
	Header      *string `json:"header"`
	Description *string `json:"description"`
	Highlight   *string `json:"highlight"`
	Image       *string `json:"thumbnail"`
	Url         string  `json:"url"`
}
