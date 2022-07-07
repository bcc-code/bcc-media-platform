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

		r, err := client.Search(c, query)

		if err != nil {
			log.L.Error().Err(err).Msg("Search failed")
			c.JSON(500, map[string]string{
				"error": "search failed",
			})
			return
		}

		c.JSON(200, r)
	}
}

//func searchKeyHandler(client *search.Service) func(*gin.Context) {
//	return func(c *gin.Context) {
//		var query common.SearchQuery
//		// define default options
//		query.Page = 0
//		err := c.BindJSON(&query)
//		if err != nil {
//			log.L.Error().Err(err)
//		}
//
//		r := client.GenerateSecureKey(c)
//
//		c.JSON(200, r)
//	}
//}
