package phrase

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/translations"
	"github.com/gin-gonic/gin"
	"github.com/redis/go-redis/v9"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/go-resty/resty/v2"
	"github.com/samber/lo"
)

var exportLanguageMap = map[string]string{
	"en": "en_us",
	"no": "nb",
}

var importLanguageMap = map[string]string{
	"en_us": "en",
	"nb":    "no",
}

func langForExport(lang string) string {
	if l, ok := exportLanguageMap[lang]; ok {
		return l
	}

	return lang
}

func langForImport(lang string) string {
	if l, ok := importLanguageMap[lang]; ok {
		return l
	}

	return lang
}

// Client for Phrase TMS based on https://cloud.memsource.com/web/docs/api
type Client struct {
	Config
	token           string
	targetLanguages []string
	tokenExpiry     time.Time
	httpClient      *resty.Client
	redisClient     *redis.Client
}

func NewClient(redisDB *redis.Client, config Config) *Client {
	baseURL := config.BaseURL
	if baseURL == "" {
		baseURL = "https://cloud.memsource.com/web/api2"
	}

	if strings.HasSuffix(baseURL, "/") {
		baseURL = baseURL[:len(baseURL)-1]
	}

	r := resty.New()
	r.BaseURL = baseURL

	return &Client{
		Config:     config,
		httpClient: r,

		redisClient: redisDB,

		// Hardcoded, because at the moment I don't see the value in allowing this to be configurable
		targetLanguages: []string{"da", "de", "en-US", "fr", "fi", "hu", "it", "nl", "pl", "pt", "ro"},
	}
}

type translationFile map[string]json.RawMessage

// SendToTranslation sends the data provided to Phrase
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
		existingLangs = append(existingLangs, langForExport(job.TargetLang))
	}

	if len(existingJobs) > 0 {
		err = m.UpdateSource(existingJobs, filename, outputData)
	}

	existingLangs = lo.Map(existingLangs, func(s string, _ int) string { return langForImport(s) })
	nonExisting, _ := lo.Difference(m.targetLanguages, existingLangs)
	if len(nonExisting) > 0 {
		err = m.CreateJob(nonExisting, "/", filename, outputData)
	}

	return err
}

var ErrUnknownProject = merry.Sentinel("unknown project, ignoring message")

func (c *Client) ProcessWebhook(ctx context.Context, originalRequest *http.Request, hookData []byte) (*translations.TranslatableCollection, []common.TranslationData, error) {
	payload := &WebhookPost{}
	err := json.Unmarshal(hookData, payload)
	if err != nil {
		return nil, nil, merry.Wrap(err)
	}

	projectToCheck := payload.Metadata.Project.UID

	if payload.AsyncRequest != nil {
		projectToCheck = payload.AsyncRequest.Project.UID
	}

	if projectToCheck != c.ProjectUID {
		return nil, nil, merry.Wrap(ErrUnknownProject)
	}

	outData := []common.TranslationData{}

	if payload.AsyncRequest != nil {
		data := map[string]json.RawMessage{}

		asyncRequestID := fmt.Sprintf("%d", payload.AsyncRequest.ID)

		fileData, err := c.DownloadFile(ctx, payload.JobParts[0].UID, asyncRequestID)
		if err != nil {
			return nil, nil, merry.Wrap(err)
		}

		err = json.Unmarshal(fileData, &data)

		collection := translations.TranslatableCollections.Parse(strings.TrimSuffix(payload.JobParts[0].FileName, ".json"))

		if err != nil {
			log.L.Error().
				Err(err).
				Str("filename", payload.JobParts[0].FileName).
				Str("data", string(fileData)).
				Msg("Unable to unmarshal json")
			return collection, nil, merry.Wrap(err)
		}

		log.L.Debug().Str("filename", payload.JobParts[0].FileName).Msg("Unmarshalled json")

		for k, v := range data {
			outData = append(outData, common.TranslationData{
				ID:       k,
				Value:    v,
				Language: langForImport(payload.JobParts[0].TargetLang),
			})
		}

		return collection, outData, nil
	}

	for _, part := range payload.JobParts {
		if !part.Status.IsCompleted() {
			continue
		}

		collection := translations.TranslatableCollections.Parse(strings.TrimSuffix(part.FileName, ".json"))
		if collection == nil {
			// Unknown collection
			log.L.Warn().Str("filename", part.FileName).Msg("Unknown collection")
			continue
		}

		err := c.GetFileAsync(ctx, part.UID)
		if err != nil {
			return collection, nil, merry.Wrap(err)
		}
		return collection, nil, nil

	}

	return nil, nil, nil
}

func (c *Client) Authenticate() error {
	if c.token != "" && c.tokenExpiry.After(time.Now()) {
		return nil
	}

	req := c.httpClient.R()
	req.SetBody(loginRequest{UserName: c.Username, Password: c.Password, UserUID: c.UserUID, Remember: true}).
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
		log.L.Error().Bytes("body", res.Body()).Str("projectID", projectID).Int("status", res.StatusCode()).Msg("Unexpected status code when fetching project")
		return nil, merry.Errorf("unable to fetch project")
	}

	return res.Result().(*Project), nil
}

func (c *Client) updateJobsStatus(jobs []Job, status Status) error {
	req := c.httpClient.R()

	req.SetBody(gin.H{"status": status, "jobs": jobs})

	res, err := req.Patch("v3/jobs")

	if err != nil {
		return err
	}

	if res.StatusCode() != 200 {
		body, _ := json.Marshal(res.Request.Body)
		log.L.Error().
			Str("projectID", c.ProjectUID).
			Int("status", res.StatusCode()).
			Bytes("body", res.Body()).
			Bytes("req_body", body).
			Msg("Unexpected status code when updating jobs")
		return merry.Errorf("unable to update jobs")
	}

	return nil
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
		Post(fmt.Sprintf("v1/projects/%s/jobs", url.PathEscape(c.ProjectUID)))

	if err != nil {
		return err
	}

	if res.StatusCode() != 201 {
		log.L.Error().Str("projectID", c.ProjectUID).Str("filename", string(res.Body())).Int("status", res.StatusCode()).Msg("Unexpected status code when creating job")
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

	err := c.updateJobsStatus(meta.Jobs, StatusNew)
	if err != nil {
		return err
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
		Post(fmt.Sprintf("v1/projects/%s/jobs/source", url.PathEscape(c.ProjectUID)))

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

	req.SetPathParam("projectID", c.ProjectUID)
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

	req.SetPathParam("projectID", c.ProjectUID)

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

func (c *Client) GetFileAsync(ctx context.Context, jobUID string) error {
	req := c.httpClient.R()

	req.SetPathParam("projectUid", c.ProjectUID)
	req.SetPathParam("jobUid", jobUID)
	req.SetBody(gin.H{"callbackUrl": c.CallbackURL})
	req.SetResult(&AsyncRequestResponse{})

	res, err := req.Put("v3/projects/{projectUid}/jobs/{jobUid}/targetFile")
	if err != nil {
		return err
	}

	if res.StatusCode() != 202 {
		log.L.Error().
			Str("jobUID", jobUID).
			Int("status", res.StatusCode()).
			Str("body", string(res.Body())).
			Msg("Unexpected status code when requesting result file")
		return err
	}

	log.L.Debug().Str("jobUID", jobUID).Str("body", string(res.Body())).Msg("Requested result file")

	responseData := req.Result.(*AsyncRequestResponse)

	requestID := responseData.AsyncRequest.ID
	webhookID := responseData.AsyncRequest.Parent.ID

	err = c.redisClient.Set(ctx, fmt.Sprintf("phrase:%s", webhookID), requestID, time.Minute*30).Err()

	if err != nil {
		log.L.Debug().Err(err).Msg("Unable to set redis key")
	}

	return err
}

func (c *Client) DownloadFile(ctx context.Context, jobUID string, asyncRequestID string) ([]byte, error) {
	req := c.httpClient.R()
	redisID := fmt.Sprintf("phrase:%s", asyncRequestID)
	downloadID, err := c.redisClient.Get(ctx, redisID).Int()
	if err != nil {
		return nil, err
	}

	req.SetPathParam("projectUid", c.ProjectUID)
	req.SetPathParam("jobUid", jobUID)
	req.SetPathParam("asyncRequestId", fmt.Sprintf("%d", downloadID))
	req.SetBody(struct{}{})
	res, err := req.Get("v2/projects/{projectUid}/jobs/{jobUid}/downloadTargetFile/{asyncRequestId}")

	if err != nil {
		return nil, err
	}

	if res.StatusCode() != 200 {
		log.L.Error().
			Str("body", string(res.Body())).
			Str("jobUID", jobUID).
			Int("status", res.StatusCode()).
			Msg("Unexpected status code when fetching file")
		return nil, fmt.Errorf("unable to fetch file, status code: %d", res.StatusCode())
	}

	return res.Body(), nil
}
