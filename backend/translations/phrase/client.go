package phrase

import (
	"context"
	"encoding/json"
	"fmt"
	"net/url"
	"strings"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/davecgh/go-spew/spew"
	"github.com/go-resty/resty/v2"
	"github.com/samber/lo"
)

// Client for Phrase TMS based on https://cloud.memsource.com/web/docs/api
type Client struct {
	baseURL         string
	token           string
	userName        string
	password        string
	projectUID      string
	targetLanguages []string
	tokenExpiry     time.Time
	httpClient      *resty.Client
}

func NewClient(baseURL string, userName, password string, projectUID string) *Client {
	if baseURL == "" {
		baseURL = "https://cloud.memsource.com/web/api2"
	}

	if strings.HasSuffix(baseURL, "/") {
		baseURL = baseURL[:len(baseURL)-1]
	}

	r := resty.New()
	r.BaseURL = baseURL

	return &Client{
		baseURL:    baseURL,
		httpClient: r,
		userName:   userName,
		password:   password,
		projectUID: projectUID,

		// Hardcoded, because at the moment I don't see the value in allowing this to be configurable
		targetLanguages: []string{"fr", "de"},
	}
}

type translationFile map[string]json.RawMessage

// SendToTranslation sends the data provided to Phrase
//
// Agreed with Milenko 2025-01-13:
// * There should be one job per logical unit (e.g. shows, questions, episodes, etc.)
// * The job should be continuously updated
func (m *Client) SendToTranslation(ctx context.Context, collection string, data []common.TranslationData) error {
	// Generate the final data structure
	outputFile := translationFile{}
	for _, d := range data {
		outputFile[d.ID] = d.Value
	}

	outputData, err := json.MarshalIndent(outputFile, "", "    ")
	if err != nil {
		return err
	}

	filename := fmt.Sprintf("%s.json", collection)

	jobs, err := m.GetJobs(filename)
	if err != nil {
		return err
	}

	existingJobs := []string{}
	existingLangs := []string{}
	// Check if we have all targetLanguages
	for _, job := range jobs {
		existingJobs = append(existingJobs, job.UID)
		existingLangs = append(existingLangs, job.TargetLang)
	}

	if len(existingJobs) > 0 {
		err = m.UpdateSource(existingJobs, filename, outputData)
	}

	nonExisting, _ := lo.Difference(m.targetLanguages, existingLangs)
	if len(nonExisting) > 0 {
		err = m.CreateJob(nonExisting, "/", filename, outputData)
	}

	return err
}

func (m *Client) ProcessWebhook(ctx context.Context, url string, hookData []byte) (collection string, data []common.TranslationData, err error) {
	return "", nil, merry.Errorf("not implemented")
}

func (c *Client) Authenticate() error {
	if c.token != "" && c.tokenExpiry.After(time.Now()) {
		return nil
	}

	req := c.httpClient.R()
	req.SetBody(loginRequest{UserName: c.userName, Password: c.password, Remember: true}).
		SetResult(&LoginResponse{})

	res, err := req.Post("v3/auth/login")

	if err != nil {
		return merry.Wrap(err)
	}

	if res.StatusCode() != 200 {
		return merry.Errorf("unexpected status code when authenticating to Phrase: %d", res.StatusCode())
	}

	respData := res.Result().(*LoginResponse)

	c.token = respData.Token

	expiry, err := time.Parse(phraseTimeFormat, respData.Expires)
	if err != nil {
		return merry.Wrap(err)
	}

	c.tokenExpiry = expiry

	c.httpClient.SetAuthScheme("ApiToken")
	c.httpClient.SetAuthToken(c.token)

	return nil
}

func (c *Client) GetProject(projectID string) (*Project, error) {
	req := c.httpClient.R()

	req.SetPathParam("projectID", projectID)
	req.SetResult(&Project{})

	res, err := req.Get("v1/projects/{projectID}")
	if err != nil {
		return nil, err
	}

	if res.StatusCode() != 200 {
		log.L.Error().Str("projectID", projectID).Int("status", res.StatusCode()).Msg("Unexpected status code when fetching project")
		return nil, merry.Errorf("unable to fetch project")
	}

	return res.Result().(*Project), nil
}

func (c *Client) CreateJob(targetLanguages []string, path, filename string, data []byte) error {
	meta := CreateJobHeader{
		TargetLangs: targetLanguages,
		Path:        path,
	}

	metaJson, err := json.Marshal(meta)
	if err != nil {
		return err
	}

	res, err := c.httpClient.R().
		SetHeader("Memsource", string(metaJson)). // Yeah.... Don't ask
		SetHeader("Content-Disposition", fmt.Sprintf(`attachment; filename="%s"`, filename)).
		SetHeader("Content-Type", "application/octet-stream").
		SetBody(data).
		Post(fmt.Sprintf("v1/projects/%s/jobs", url.PathEscape(c.projectUID)))

	if err != nil {
		return err
	}

	spew.Dump(string(res.Body()))

	if res.StatusCode() != 201 {
		log.L.Error().Str("projectID", c.projectUID).Str("filename", string(res.Body())).Int("status", res.StatusCode()).Msg("Unexpected status code when creating job")
		return merry.Errorf("unable to fetch project")
	}

	return nil

}

func (c *Client) UpdateSource(jobs []string, filename string, data []byte) error {
	meta := UpdateSourceRequest{
		Jobs:                       lo.Map(jobs, func(j string, _ int) Job { return Job{UID: j} }),
		PreTranslate:               true,
		AllowAutomaticPostAnalysis: true,
	}

	metaJson, err := json.Marshal(meta)
	if err != nil {
		return err
	}

	res, err := c.httpClient.R().
		SetHeader("Memsource", string(metaJson)).
		SetHeader("Content-Disposition", fmt.Sprintf(`attachment; filename="%s"`, filename)).
		SetHeader("Content-Type", "application/octet-stream").
		SetBody(data).
		Post(fmt.Sprintf("v1/projects/%s/jobs/source", url.PathEscape(c.projectUID)))

	if err != nil {
		return err
	}

	if res.StatusCode() != 200 {
		return fmt.Errorf("unexpected status code when updating source: %d, (%s)", res.StatusCode(), string(res.Body()))
	}

	return nil
}

func (c *Client) GetJob(jobUID string) (*Job, error) {
	req := c.httpClient.R()

	req.SetPathParam("projectID", c.projectUID)
	req.SetPathParam("jobUID", jobUID)

	req.SetResult(&Job{})

	res, err := req.Get("v1/projects/{projectID}/jobs/{jobUID}")
	if err != nil {
		return nil, err
	}

	if res.StatusCode() != 200 {
		log.L.Error().Str("jobUID", jobUID).Int("status", res.StatusCode()).Msg("Unexpected status code when fetching job")
		return nil, err
	}

	return res.Result().(*Job), nil
}

func (c *Client) GetJobs(filename string) ([]Job, error) {
	req := c.httpClient.R()

	req.SetPathParam("projectID", c.projectUID)

	if filename != "" {
		req.SetQueryParam("filename", filename)
	}

	req.SetResult(&JobsList{})

	res, err := req.Get("v1/projects/{projectID}/jobs")
	if err != nil {
		return nil, err
	}

	if res.StatusCode() != 200 {
		log.L.Error().Int("status", res.StatusCode()).Msg("Unexpected status code when fetching jobs")
		return nil, err
	}

	return res.Result().(*JobsList).Content, nil
}

func (c *Client) ExtractCompletedJobFromWebhook(data []byte) ([]string, error) {
	var webhook WebhookEvent

	err := json.Unmarshal(data, &webhook)
	if err != nil {
		return nil, err
	}

	if webhook.Metadata.Project.UID != c.projectUID {
		return []string{}, nil
	}

	out := make([]string, 0, len(webhook.JobParts))
	for _, j := range webhook.JobParts {
		if j.Status.IsCompleted() {
			out = append(out, j.UID)
		}
	}

	return out, nil
}

func (c *Client) GetFile(jobUID string) (*ResultFileRequest, error) {
	req := c.httpClient.R()

	req.SetPathParam("projectUid", c.projectUID)
	req.SetPathParam("jobUid", jobUID)
	req.SetBody(struct{}{})
	req.SetResult(&ResultFileRequest{})

	res, err := req.Put("v3/projects/{projectUid}/jobs/{jobUid}/targetFile")
	if err != nil {
		return nil, err
	}

	if res.StatusCode() != 202 {
		log.L.Error().Str("jobUID", jobUID).Int("status", res.StatusCode()).Msg("Unexpected status code when requesting result file")
		return nil, err
	}

	for i := 0; i < 10; i++ {
		time.Sleep(5 * time.Second)

		req = c.httpClient.R()

		req.SetPathParam("projectUid", c.projectUID)
		req.SetPathParam("jobUid", jobUID)
		req.SetPathParam("asyncRequestId", res.Result().(*ResultFileRequest).AsyncRequest.ID)
		req.SetBody(struct{}{})
		req.SetResult(&ResultFileRequest{})
		res, err = req.Get("v2/projects/{projectUid}/jobs/{jobUid}/downloadTargetFile/{asyncRequestId}")

		if err != nil {
			return nil, err
		}

		if res.StatusCode() != 200 {
			log.L.Error().Str("jobUID", jobUID).Int("status", res.StatusCode()).Msg("Unexpected status code when fetching file")
			continue
		}

		spew.Dump(string(res.Body()))
		break
	}

	return nil, nil
}
