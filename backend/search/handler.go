package search

import "github.com/bcc-code/brunstadtv/backend/base"

type Handler struct {
	user    any
	service *Service
}

func (service *Service) GetHandler(user any) base.ISearchHandler {
	return &Handler{
		user:    user,
		service: service,
	}
}
