package main

import (
	"encoding/json"
	"strconv"
	"strings"
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

	// TODO: also build schema with translated fields: {field}.{languageCode}
	collectionName := "medias_" + time.Now().Format("20060102150405")
	schema := &api.CollectionSchema{
		Name: collectionName,
		Fields: []api.Field{
			{
				Name: "id",
				Type: "string",
			},
			{
				Name: "type",
				Type: "string",
			},
			{
				Name: "title",
				Type: "string",
			},
			{
				Name:     "showTitle",
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "seasonTitle",
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "sequenceNumber",
				Type:     "int32",
				Optional: true,
			},
			{
				Name:     "tags",
				Type:     "string[]",
				Optional: true,
			},
			{
				Name:     "title",
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "description",
				Type:     "string[]",
				Optional: true,
			},
			{
				Name:     "longDescription",
				Type:     "string[]",
				Optional: true,
			},
		},
	}

	_, err := client.Collections().Create(schema)
	if err != nil {
		log.L.Error().Msg("Couldnt create collection. Err: " + err.Error())
		c.Status(500)
		return
	}

	medias, err := s.Server.queries.GetMediaSearchDocs(c.Request.Context())
	if err != nil {
		log.L.Error().Msg("Couldnt get medias. Err: " + err.Error())
		c.Status(500)
		return
	}
	mediaTranslations, err := s.Server.queries.GetMediaTranslations(c.Request.Context())
	if err != nil {
		log.L.Error().Msg("Couldnt get mediatranslations. Err: " + err.Error())
		c.Status(500)
		return
	}

	documents := ""
	for _, media := range medias {

		// So first marshal the mediasearchdoc to { "id": "something", "sequenceNumber": 2, "primaryGroupID": 1012, ... }
		initialJson, _ := json.Marshal(media)
		mediaMap := make(map[string]interface{})
		json.Unmarshal(initialJson, &mediaMap)

		// Then create the translations map
		translations := make(map[string]string)
		for _, t := range mediaTranslations {
			if t.MediaID.Int64 == media.ID {
				translations["title."+t.LanguageCode] = t.Title.String
				translations["description."+t.LanguageCode] = t.Description.String
				translations["longDescription."+t.LanguageCode] = t.LongDescription.String
			}
			if media.PrimaryGroupID.Valid && media.PrimaryGroupID.Int64 == t.MediaID.Int64 {
				translations["parentTitle."+t.LanguageCode] = t.Title.String
				translations["parentDescription."+t.LanguageCode] = t.Description.String
				translations["parentLongDescription."+t.LanguageCode] = t.LongDescription.String
			}
			if media.GrandparentID.Valid && media.GrandparentID.Int64 == t.MediaID.Int64 {
				translations["grandparentTitle."+t.LanguageCode] = t.Title.String
				translations["grandparentDescription."+t.LanguageCode] = t.Description.String
				translations["grandparentLongDescription."+t.LanguageCode] = t.LongDescription.String
			}
		}
		json.Marshal(translations)

		// then merge the two
		for k, v := range translations {
			mediaMap[k] = v
		}

		// and throw it in as jsonl (https://jsonlines.org/)
		mediaMap["id"] = strconv.Itoa(int(media.ID))
		mediaJson, _ := json.Marshal(mediaMap)
		documents += string(mediaJson) + "\n"
	}

	params := &api.ImportDocumentsParams{
		Action:    "",
		BatchSize: 40,
	}
	res, err := client.Collection(collectionName).Documents().ImportJsonl(strings.NewReader(documents), params)
	if err != nil {
		log.L.Error().Msg("Typesense api call failed. Err: " + err.Error())
		c.Status(500)
		return
	}
	defer res.Close()
	jd := json.NewDecoder(res)
	for jd.More() {
		var response string
		jd.Decode(&response)
		print(response)
	}
}
