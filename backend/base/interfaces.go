package base

type ISearchService interface {
	Reindex()
	DeleteObject(item interface{})
	DeleteModel(model string, id int)
	IndexObject(item interface{})
	IndexModel(model string, id int)
	GetHandler(user any) ISearchHandler
}

type ISearchHandler interface {
	Search(query *SearchQuery) (*SearchResult, error)
}
