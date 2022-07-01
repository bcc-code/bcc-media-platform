package main

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
)

func searchQueryHandler(client *search.Service) func(*gin.Context) {
	return func(c *gin.Context) {
		var query common.SearchQuery
		// define default options
		query.Page = 0
		err := c.BindJSON(&query)
		if err != nil {
			log.L.Error().Err(err)
		}

		searchHandler := client.NewRequestHandler()
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

		searchHandler := client.NewRequestHandler()
		r := searchHandler.GenerateSecureKey()

		c.JSON(200, r)
	}
}
