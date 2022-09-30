package main

import (
	"encoding/json"
	"github.com/ansel1/merry/v2"
	"io"
	"log"
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
		Title       string
		Description string
		Image       *string
		Number      *int
		Season      struct {
			Title string
		}
	}
}

type season struct {
	Season struct {
		Title       string
		Description string
		Image       *string
		Number      int
		Show        struct {
			Title string
		}
	}
}

type show struct {
	Show struct {
		Title       string
		Description string
		Image       *string
	}
}

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

	resString, _ := io.ReadAll(res.Body)

	if res.StatusCode < 200 || res.StatusCode > 299 {
		log.Default().Print(merry.New("Error occurred when fetching", merry.WithHTTPCode(res.StatusCode), merry.WithMessage(string(resString))))
		return nil
	}

	var r response[T]
	err = json.Unmarshal(resString, &r)
	if err != nil || r.Errors != nil {
		return nil
	}
	return &r.Data
}

func getEpisode(id string) *episode {
	return get[episode](`
query getEpisode($id: ID!) {
    episode(id: $id) {
        title
        description
        image
        number
        season {
            title
            show {
                title
            }
        }
    }
}
`, map[string]any{
		"id": id,
	})
}

func getSeason(id string) *season {
	return get[season](`
query getSeason($id: ID!) {
    season(id: $id) {
        title
        description
        image
        number
        show {
            title
        }
    }
}
`, map[string]any{
		"id": id,
	})
}

func getShow(id string) *show {
	return get[show](`
query getShow($id: ID!) {
    show(id: $id) {
        title
        description
        image
    }
}
`, map[string]any{
		"id": id,
	})
}
