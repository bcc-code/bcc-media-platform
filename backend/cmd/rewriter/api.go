package main

import (
	_ "embed"
	"encoding/json"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"io"
	"net/http"
	"os"
	"strings"
)

type response[T any] struct {
	Data   T
	Errors []any
}

type episode struct {
	Episode struct {
		Index  bool
		Title  string
		Image  *string
		Number *int
		Season struct {
			Title string
			Show  struct {
				Title string
			}
		}
	}
}

//type season struct {
//	Season struct {
//		Title       string
//		Description string
//		Image       *string
//		Number      int
//		Show        struct {
//			Title string
//		}
//	}
//}
//
//type show struct {
//	Show struct {
//		Title       string
//		Description string
//		Image       *string
//	}
//}

var apiEndpoint = os.Getenv("API_ENDPOINT")

func get[T any](query string, variables map[string]any) *T {
	body, err := json.Marshal(map[string]any{
		"query":     query,
		"variables": variables,
	})

	req, err := http.NewRequest("POST", apiEndpoint, strings.NewReader(string(body)))
	if err != nil {
		return nil
	}
	req.Header.Set("Content-Type", "application/json")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil
	}
	defer utils.LogError(res.Body.Close)

	resString, err := io.ReadAll(res.Body)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to read response body")
		return nil
	}

	if res.StatusCode < 200 || res.StatusCode > 299 {
		log.L.Error().Err(merry.New("Error occurred when fetching", merry.WithHTTPCode(res.StatusCode), merry.WithMessage(string(resString)))).Msg("Failed to retrieve from API")
		return nil
	}

	var r response[T]
	err = json.Unmarshal(resString, &r)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to unmarshal response")
		return nil
	}
	if r.Errors != nil {
		// Usually just permissions or not found errors. Ignore
		return nil
	}
	return &r.Data
}

//go:embed queries/episode.graphql
var episodeQuery string

func getEpisode(id string) *episode {
	return get[episode](episodeQuery, map[string]any{
		"id": id,
	})
}

////go:embed queries/season.graphql
//var seasonQuery string
//
//func getSeason(id string) *season {
//	return get[season](seasonQuery, map[string]any{
//		"id": id,
//	})
//}
//
////go:embed queries/show.graphql
//var showQuery string
//
//func getShow(id string) *show {
//	return get[show](showQuery, map[string]any{
//		"id": id,
//	})
//}
