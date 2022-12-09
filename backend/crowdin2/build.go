package crowdin2

import (
	"context"
	"fmt"
	"github.com/davecgh/go-spew/spew"
	"github.com/gocarina/gocsv"
	"net/http"
	"time"
)

//// List retrieves all translations
//func (c *Client) List(ctx context.Context, collection string) map[string]common.LocaleMap[string] {
//	res, err := get(ctx, c, "")
//}

type buildProjectRequest struct {
	ExportApprovedOnly    bool `json:"exportApprovedOnly"`
	SkipUntranslatedFiles bool `json:"skipUntranslatedFiles"`
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

func (c *Client) buildProject(ctx context.Context, projectID int) (string, error) {
	body := buildProjectRequest{
		ExportApprovedOnly:    true,
		SkipUntranslatedFiles: true,
	}

	res, err := post[buildProjectResponse](ctx, c, fmt.Sprintf("projects/%d/translations/builds", projectID), body)
	if err != nil {
		return "", err
	}

	looped := 0

	for true {
		if looped > 300 {
			// If it exceeds 5 minutes to run this, then something probably should be rewritten
			break
		}
		time.Sleep(time.Second * 1)

		res, err = get[buildProjectResponse](ctx, c, fmt.Sprintf("projects/%d/translations/builds/%d", projectID, res.ID))
		if err != nil {
			return "", err
		}

		if res.Status == "finished" {
			break
		}
		looped++
	}

	build, err := get[projectBuildResponse](ctx, c, fmt.Sprintf("projects/%d/translations/builds/%d/download", projectID, res.ID))
	if err != nil {
		return "", err
	}

	resp, err := http.Get(build.URL)
	if err != nil {
		return "", err
	}

	csv, err := gocsv.CSVToMap(resp.Body)
	if err != nil {
		return "", err
	}

	spew.Dump(csv)
	return "", nil
}
