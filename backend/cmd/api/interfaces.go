package main

type ISearchService interface {
	Reindex()
	DeleteObject(item interface{})
	DeleteModel(model string, id int)
	IndexObject(item interface{})
	IndexModel(model string, id int)
}
