package main

import (
	"github.com/bcc-code/brunstadtv/backend/base"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
)

func searchIndexHandler(apiKey string, client base.ISearchService) func(*gin.Context) {
	return func(c *gin.Context) {
		err := authenticateRequestWithXApiKey(apiKey, c)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to authenticate request")
			return
		}
		client.Reindex()
		_, _ = c.Writer.WriteString("Indexed all documents")
	}
}

func searchQueryHandler(client base.ISearchService) func(*gin.Context) {
	return func(c *gin.Context) {
		var query base.SearchQuery
		// define default options
		query.Page = 0
		err := c.BindJSON(&query)
		if err != nil {
			log.L.Error().Err(err)
		}

		searchHandler := client.GetQueryHandler("not a user but its a user")
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

func directusEventHandler(apiKey string, searchService base.ISearchService) func(c *gin.Context) {
	eventHandler := directus.NewEventHandler()

	indexEvents := []string{directus.EventItemsCreate, directus.EventItemsUpdate}
	eventHandler.On(indexEvents, searchService.IndexModel)

	deleteEvents := []string{directus.EventItemsDelete}
	eventHandler.On(deleteEvents, searchService.DeleteModel)

	return func(c *gin.Context) {
		err := authenticateRequestWithXApiKey(apiKey, c)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to authenticate")
			return
		}
		eventHandler.Execute(c)
	}
}

func configureSearchEndpoints(r *gin.Engine, config envConfig, searchService *search.Service) {
	searchGroup := r.Group("search")
	searchGroup.POST("query", searchQueryHandler(searchService))

	// Hooks and scheduling for search indexing
	if config.SchedulerSecret != "" {
		log.L.Debug().Msg("Setting up endpoint for scheduled search indexing")
		searchGroup.GET("index", searchIndexHandler(config.SchedulerSecret, searchService))
	} else {
		log.L.Debug().Msg("Missing secret for scheduler endpoint, skipping endpoint configuration")
	}

	if config.DirectusSecret != "" {
		log.L.Debug().Msg("Setting up endpoint for webhooks from Directus")
		r.POST("/directus/webhook", directusEventHandler(config.DirectusSecret, searchService))
	} else {
		log.L.Debug().Msg("Missing secret for webhooks from Directus, skipping endpoint configuration")
	}
}
