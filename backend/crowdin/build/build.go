package build

import (
	"archive/zip"
	"context"
	"fmt"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gocarina/gocsv"
	"github.com/samber/lo"
	"io"
	"net/http"
	"os"
	"strings"
	"time"
)

//// List retrieves all translations
//func (c *Client) List(ctx context.Context, collection string) map[string]common.LocaleMap[string] {
//	res, err := get(ctx, c, "")
//}

type buildProjectRequest struct {
	ExportApprovedOnly      bool `json:"exportApprovedOnly"`
	SkipUntranslatedStrings bool `json:"skipUntranslatedStrings"`
}

type buildProjectResponse struct {
	ID         int
	ProjectID  int
	Status     string
	Progress   int
	CreatedAt  time.Time
	UpdatedAt  time.Time
	FinishedAt time.Time
}

type projectBuildResponse struct {
	URL      string
	ExpireIn time.Time
}

// List translations in crowdin
func (c *Client) List(ctx context.Context) ([]Translation, error) {
	var translations []Translation
	for _, id := range c.config.ProjectIDs {
		ts, err := c.buildProject(ctx, id)
		if err != nil {
			return nil, err
		}
		translations = append(translations, ts...)
	}
	return translations, nil
}

func (c *Client) buildProject(ctx context.Context, projectID int) ([]Translation, error) {
	body := buildProjectRequest{
		ExportApprovedOnly:      true,
		SkipUntranslatedStrings: true,
	}

	res, err := post[buildProjectResponse](ctx, c, fmt.Sprintf("projects/%d/translations/builds", projectID), body)
	if err != nil {
		return nil, err
	}

	// Prevent waiting for too long. 5 minutes should be plenty of time.
	const loopMax = 60
	const sleepSeconds = 5

	for i := 0; i < loopMax; i++ {
		time.Sleep(time.Second * sleepSeconds)

		res, err = get[buildProjectResponse](ctx, c, fmt.Sprintf("projects/%d/translations/builds/%d", projectID, res.ID))
		if err != nil {
			return nil, err
		}

		log.L.Debug().Int("buildID", res.ID).
			Str("status", res.Status).
			Msg("Checked build status")

		if res.Status == "finished" {
			break
		}
	}

	build, err := get[projectBuildResponse](ctx, c, fmt.Sprintf("projects/%d/translations/builds/%d/download", projectID, res.ID))
	if err != nil {
		return nil, err
	}

	resp, err := http.Get(build.URL)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	return handleBody(resp.Body, fmt.Sprintf("crowdin-build-%d", res.ID))
}

func handleBody(body io.ReadCloser, fileName string) ([]Translation, error) {
	out, err := os.Create(fileName + ".zip")
	if err != nil {
		return nil, err
	}
	defer out.Close()

	io.Copy(out, body)

	return GetTranslationsFromZip(out.Name())
}

func handleErr(errFunc func() error) {
	if err := errFunc(); err != nil {
		log.L.Error().Err(err).Msg("Error occurred")
	}
}

func languageCode(language string) string {
	switch language {
	case "nb":
		return "no"
	default:
		if strings.Contains(language, "-") {
			return strings.Split(language, "-")[0]
		}
	}
	return language
}

// Translation contains data for a specific translation key
type Translation struct {
	Collection string
	ID         string
	Field      string
	Value      string
	Language   string
}

// GetTranslationsFromZip retrieves translations from a zip containing csv files
func GetTranslationsFromZip(zipFile string) ([]Translation, error) {
	reader, err := zip.OpenReader(zipFile)
	if err != nil {
		return nil, err
	}
	defer handleErr(reader.Close)

	var ts []Translation

	for _, file := range reader.File {
		fileReader, err := file.Open()
		if err != nil {
			return nil, err
		}
		if !strings.HasSuffix(file.Name, ".csv") {
			continue
		}
		log.L.Debug().Str("name", file.Name).Msg("Processing file")

		csvMap, err := gocsv.CSVToMap(fileReader)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to read file")
			continue
		}
		filteredMap := map[string]string{}
		for key, value := range csvMap {
			if value != "" {
				filteredMap[key] = value
			}
		}
		if len(filteredMap) == 0 {
			continue
		}
		path := strings.Split(file.Name, "/")
		language := languageCode(path[0])
		for key, value := range filteredMap {
			parts := strings.Split(key, "-")
			collection := parts[0]
			id := strings.Join(parts[1:len(parts)-1], "-")
			field, _ := lo.Last(parts)

			ts = append(ts, Translation{
				Language:   language,
				ID:         id,
				Collection: collection,
				Field:      field,
				Value:      value,
			})
		}

		err = fileReader.Close()
		if err != nil {
			return nil, err
		}
	}

	err = os.Remove(zipFile)
	if err != nil {
		return nil, err
	}
	return ts, nil
}
