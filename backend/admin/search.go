package main

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/typesense/typesense-go/typesense"
	"github.com/typesense/typesense-go/typesense/api"
	"github.com/typesense/typesense-go/typesense/api/pointer"
	"go.bcc.media/brunstadtv/log"
)

type SearchServer struct {
	ApiKey       string
	TypesenseUrl string
	Server       *Server
}

// This is meant to be run on a schedule
func (s *SearchServer) Index(c *gin.Context) {
	client := typesense.NewClient(
		typesense.WithServer(s.TypesenseUrl),
		typesense.WithAPIKey(s.ApiKey),
		typesense.WithConnectionTimeout(5*time.Second),
		typesense.WithCircuitBreakerMaxRequests(50),
		typesense.WithCircuitBreakerInterval(2*time.Minute),
		typesense.WithCircuitBreakerTimeout(1*time.Minute),
	)

	previousCollection, err := client.Alias("medias").Retrieve()
	if err != nil {
		log.L.Warn().Msg("Couldnt retrieve previous collection. Err: " + err.Error())
	}

	fields := []api.Field{
		{
			Name: "id",
			Type: "string",
		},
		{
			Name: "title",
			Type: "string",
		},
		{
			Name:  "mediaType",
			Type:  "string",
			Facet: true,
		},
		{
			Name:     "availableFrom",
			Type:     "int64",
			Optional: true,
		},
		{
			Name:     "availableTo",
			Type:     "int64",
			Optional: true,
		},
		{
			Name:     "usergroups",
			Type:     "string[]",
			Optional: false,
		},
		{
			Name:     "sequenceNumber",
			Type:     "int32",
			Optional: true,
		},
		{
			Name:     "TranslatedFields",
			Type:     "string",
			Index:    pointer.False(),
			Optional: true,
		},
	}

	languages, err := s.Server.queries.GetLanguages(c.Request.Context())
	if err != nil {
		log.L.Error().Msg("Couldnt get languages. Err: " + err.Error())
		c.Status(500)
		return
	}

	for _, language := range languages {
		fields = append(fields, []api.Field{
			{
				Name:     "title." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "description." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "longDescription." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "parentTitle." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "parentDescription." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "parentLongDescription." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "grandparentTitle." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "grandparentDescription." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "grandparentLongDescription." + language.Code,
				Type:     "string",
				Optional: true,
			},
			{
				Name:     "tags." + language.Code,
				Facet:    true,
				Type:     "string[]",
				Optional: true,
			},
		}...)
	}

	collectionName := "medias_" + time.Now().Format("20060102150405")
	schema := &api.CollectionSchema{
		Name:   collectionName,
		Fields: fields,
	}

	_, err = client.Collections().Create(schema)
	if err != nil {
		log.L.Error().Msg("Couldnt create collection. Err: " + err.Error())
		c.Status(500)
		return
	}

	wasSuccessful := false
	abort := func() {
		_, err := client.Collection(collectionName).Delete()
		if err != nil {
			log.L.Error().Msg("Typesense collection delete also failed. Err: " + err.Error())
			c.Status(500)
		}
	}
	// TODO: There is a more idiomatic way of doing this with select {}
	go func() {
		<-c.Request.Context().Done()
		if !wasSuccessful {
			abort()
		}
	}()

	medias, err := s.Server.queries.GetMediaSearchDocs(c.Request.Context())
	if err != nil {
		log.L.Error().Msg("Couldnt get medias. Err: " + err.Error())
		c.Status(500)
		abort()
		return
	}
	mediaTranslations, err := s.Server.queries.GetMediaTranslations(c.Request.Context())
	if err != nil {
		log.L.Error().Msg("Couldnt get mediatranslations. Err: " + err.Error())
		c.Status(500)
		abort()
		return
	}

	documents := ""
	for _, media := range medias {
		if media.Usergroups == nil {
			media.Usergroups = []string{}
		}
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

	params := &api.ImportDocumentsParams{Action: "create"}
	fmt.Println(documents)
	reader := strings.NewReader(documents)
	res, err := client.Collection(collectionName).Documents().ImportJsonl(reader, params)
	if err != nil {
		log.L.Error().Msg("Typesense import failed. Err: " + err.Error())
		c.Status(500)
		abort()
		return
	}
	defer res.Close()
	jd := json.NewDecoder(res)
	for jd.More() {
		var response api.ImportDocumentResponse
		jd.Decode(&response)
		fmt.Print(string(response.Error))
		fmt.Print(string(response.Document))
		if !response.Success {
			log.L.Error().Msgf("Error: %s", response.Error)
			log.L.Error().Msgf("Document: %s", response.Document)
			c.Status(500)
			abort()
			return
		}
	}
	_, err = client.Aliases().Upsert("medias", &api.CollectionAliasSchema{CollectionName: collectionName})
	if err != nil {
		log.L.Error().Msg("Typesense alias upsert failed. Err: " + err.Error())
		c.Status(500)
		abort()
		return
	}

	wasSuccessful = true
	_, err = client.Collection(previousCollection.CollectionName).Delete()
	if err != nil {
		log.L.Error().Msg("Old collection delete failed. Err: " + err.Error())
	}
}
