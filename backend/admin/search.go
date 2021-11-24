package main

import (
	"context"
	"encoding/json"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/typesense/typesense-go/typesense"
	"github.com/typesense/typesense-go/typesense/api"
	"go.bcc.media/brunstadtv/log"
)

type SearchServer struct {
	ApiKey       string
	TypesenseUrl string
	Server       *Server
}

func (s *SearchServer) Index(c *gin.Context) {
	client := typesense.NewClient(
		typesense.WithServer(s.TypesenseUrl),
		typesense.WithAPIKey(s.ApiKey),
		typesense.WithConnectionTimeout(5*time.Second),
		typesense.WithCircuitBreakerMaxRequests(50),
		typesense.WithCircuitBreakerInterval(2*time.Minute),
		typesense.WithCircuitBreakerTimeout(1*time.Minute),
	)
	collectionName := "medias_" + time.Now().String()
	schema := &api.CollectionSchema{
		Name: collectionName,
		Fields: []api.Field{
			{
				Name: "Title",
				Type: "string",
			},
		},
	}

	_, err := client.Collections().Create(schema)
	if err != nil {
		log.L.Error().Msg("Couldnt create collection. Err: " + err.Error())
		c.Status(500)
		return
	}

	medias, err := s.Server.queries.GetMedias(context.Background())
	if err != nil {
		log.L.Error().Msg("Couldnt get medias")
		c.Status(500)
		return
	}

	var documents []interface{}
	for _, media := range medias {
		doc := struct {
			Title string
		}{}
		jsoned, _ := json.Marshal(media)
		json.Unmarshal(jsoned, &doc)
		documents = append(documents, doc)
	}

	client.Collection(collectionName).Documents().Import(documents, &api.ImportDocumentsParams{})
}
