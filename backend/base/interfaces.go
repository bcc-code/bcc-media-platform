package base

type ISearchService interface {
	Reindex()
	DeleteObject(item interface{})
	DeleteModel(model string, id int)
	IndexObject(item interface{})
	IndexModel(model string, id int)
	GetQueryHandler(user any) ISearchQueryHandler
}

type ISearchQueryHandler interface {
	Search(query *SearchQuery) (*SearchResult, error)
}
