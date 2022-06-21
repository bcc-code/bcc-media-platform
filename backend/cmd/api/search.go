package main

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
)

func searchIndexHandler(apiKey string, client *search.Service) func(*gin.Context) {
	return func(c *gin.Context) {
		err := authenticateRequestWithXApiKey(apiKey, c)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to authenticate request")
			return
		}
		handler := client.NewRequestHandler(c)
		handler.Reindex()
		_, _ = c.Writer.WriteString("Indexed all documents")
	}
}

func searchQueryHandler(client *search.Service) func(*gin.Context) {
	return func(c *gin.Context) {
		var query common.SearchQuery
		// define default options
		query.Page = 0
		err := c.BindJSON(&query)
		if err != nil {
			log.L.Error().Err(err)
		}

		searchHandler := client.NewRequestHandler(c)
		r, err := searchHandler.Search(&query)

		if err != nil {
			log.L.Error().Err(err).Msg("Searching failed")
			c.JSON(500, map[string]string{
				"error": "search failed",
			})
			return
		}

		c.JSON(200, r)
	}
}

func searchKeyHandler(client *search.Service) func(*gin.Context) {
	return func(c *gin.Context) {
		var query common.SearchQuery
		// define default options
		query.Page = 0
		err := c.BindJSON(&query)
		if err != nil {
			log.L.Error().Err(err)
		}

		searchHandler := client.NewRequestHandler(c)
		r := searchHandler.GenerateSecureKey()

		c.JSON(200, r)
	}
}

func directusEventHandler(apiKey string, searchService *search.Service) func(c *gin.Context) {
	eventHandler := directus.NewEventHandler()

	indexEvents := []string{directus.EventItemsCreate, directus.EventItemsUpdate}

	eventHandler.On(indexEvents, func(ctx context.Context, model string, id int) {
		handler := searchService.NewRequestHandler(ctx)
		handler.IndexModel(model, id)
	})

	deleteEvents := []string{directus.EventItemsDelete}
	eventHandler.On(deleteEvents, func(ctx context.Context, model string, id int) {
		handler := searchService.NewRequestHandler(ctx)
		handler.DeleteModel(model, id)
	})

	return func(c *gin.Context) {
		err := authenticateRequestWithXApiKey(apiKey, c)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to authenticate")
			return
		}
		eventHandler.Execute(c)
	}
}
