package crowdin

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"strconv"
	"strings"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/go-resty/resty/v2"
	"github.com/samber/lo"
)

// Fields
const (
	TitleField       = "title"
	DescriptionField = "description"
	PlaceholderField = "placeholder"
)

// Config for the client
type Config struct {
	Token      string
	ProjectIDs []int
}

// Client for crowdin interactions
type Client struct {
	c        *resty.Client
	du       *directus.Handler
	config   Config
	q        *sqlc.Queries
	readonly bool
}

// ErrRequestFailed error for failed requests
var ErrRequestFailed = merry.Sentinel("Request failed")

func ensureSuccess(res *resty.Response) error {
	if res.IsError() {
		return merry.Wrap(ErrRequestFailed, merry.WithHTTPCode(res.StatusCode()), merry.WithMessage(res.String()))
	}
	return nil
}

// New client for requests
func New(config Config, directusHandler *directus.Handler, queries *sqlc.Queries, readonly bool) *Client {
	c := resty.New().
		SetBaseURL("https://api.crowdin.com/api/v2/").
		SetAuthToken(config.Token)
	return &Client{
		du:       directusHandler,
		c:        c,
		config:   config,
		q:        queries,
		readonly: readonly,
	}
}

func getItem[t any](client *Client, endpoint string, id int) (item t, err error) {
	req := client.c.R()
	req.SetResult(Object[t]{})
	query := fmt.Sprintf("/%s/%d", endpoint, id)
	res, err := req.Get(query)
	if err != nil {
		log.L.Error().Err(err).
			Str("endpoint", endpoint).
			Str("id", strconv.Itoa(id)).
			Msg("Failed to retrieve item")
		return
	}
	err = ensureSuccess(res)
	if err == nil {
		item = res.Result().(*Object[t]).Data
	}
	return
}

func getItems[t any](client *Client, endpoint string, limit int, offset int, queryParams map[string]string) (items []t, err error) {
	req := client.c.R()
	req.SetResult(Result[[]Object[t]]{})
	if queryParams != nil {
		req.SetQueryParams(queryParams)
	}
	req.SetQueryParams(map[string]string{
		"limit":  strconv.Itoa(limit),
		"offset": strconv.Itoa(offset),
	})
	query := fmt.Sprintf("/%s", endpoint)
	res, err := req.Get(query)
	if err != nil {
		log.L.Error().Err(err).
			Str("endpoint", endpoint).
			Msg("Failed to retrieve items")
		return
	}
	err = ensureSuccess(res)
	if err == nil {
		items = lo.Map(res.Result().(*Result[[]Object[t]]).Data, func(i Object[t], _ int) t {
			return i.Data
		})
	}
	return
}

func createItem[t any](client *Client, endpoint string, item t) (i t, err error) {
	req := client.c.R()
	req.SetBody(item)
	req.SetResult(Object[t]{})
	res, err := req.Post(endpoint)
	if err != nil {
		log.L.Error().Err(err).
			Str("endpoint", endpoint).
			Msg("Failed to create item")
		return
	}
	err = ensureSuccess(res)
	if err != nil {
		return
	} else {
		i = res.Result().(*Object[t]).Data
	}
	return
}

type simpleTranslation struct {
	ID       string
	ParentID string
	Values   map[string]string
	Language string
	Changed  bool
}

func convertTsToStrings(ts []simpleTranslation, prefix string, contextFactory func(parentID string) string) []String {
	return lo.Reduce(ts, func(stringObjects []String, t simpleTranslation, _ int) []String {
		var values = t.Values
		for key, value := range values {
			if value != "" {
				str := String{
					Identifier: fmt.Sprintf("%s-%s-%s", prefix, t.ParentID, key),
					Text:       value,
				}

				if contextFactory != nil {
					str.Context = contextFactory(t.ParentID)
				}

				stringObjects = append(stringObjects, str)
			}
		}
		return stringObjects
	}, []String{})
}

var directoryCache = cache.New[int, Directory]()

func (c *Client) getDirectoryForProject(project Project) (d Directory, err error) {
	if dir, ok := directoryCache.Get(project.ID); ok {
		return dir, nil
	}

	directories, err := c.getDirectories(project.ID)
	if err != nil {
		return
	}

	var directory *Directory
	for _, dir := range directories {
		if dir.Name == "content" {
			directory = &dir
		}
	}
	if directory == nil {
		dir, err := createItem(c, fmt.Sprintf("projects/%d/directories", project.ID), Directory{
			Name: "content",
		})
		if err != nil {
			return d, err
		}
		directory = &dir
	}

	directoryCache.Set(project.ID, *directory, cache.WithExpiration(time.Minute*5))

	return *directory, nil
}

func (c *Client) getFileForCollection(project Project, directoryId int, collection string) (file File, found bool, err error) {
	files, err := c.getFiles(project.ID, directoryId)
	if err != nil {
		return
	}
	if len(files) > 0 {
		for _, f := range files {
			if f.Title == collection {
				found = true
				file = f
			}
		}
	}
	return
}

func prepareStr(source string) string {
	return source
	//reg := regexp.MustCompile("[^a-zA-Z\\d]+")
	//return reg.ReplaceAllString(source, "")
}

func strEqual(source string, compare string) bool {
	trimSource := prepareStr(source)
	trimCompare := prepareStr(compare)
	return trimSource == trimCompare
}

func dbString(source string) string {
	return strings.Replace(source, "\"\"", "\"", -1)
}

func crowdinString(source string) string {
	return strings.Replace(source, "\"", "\"\"", -1)
}

func dbLanguage(language string) string {
	if strings.Contains(language, "-") {
		return strings.Split(language, "-")[0]
	}
	return language
}

type hasStatus interface {
	UID() string
	GetStatus() common.Status
}

var projectCache = cache.New[int, Project]()

func (c *Client) getProject(projectId int) (i Project, err error) {
	if p, ok := projectCache.Get(projectId); ok {
		return p, nil
	}
	i, err = getItem[Project](c, "projects", projectId)
	if err != nil {
		return
	}
	projectCache.Set(projectId, i, cache.WithExpiration(time.Minute*5))
	return
}

// Sync synchronizes translations from Directus to Crowdin
func (c *Client) Sync(ctx context.Context, d *directus.Handler) error {
	log.L.Debug().Msg("Translation sync: Started")
	projectIds := c.config.ProjectIDs
	for _, id := range projectIds {
		project, err := c.getProject(id)
		if err != nil {
			return err
		}
		directory, err := c.getDirectoryForProject(project)
		if err != nil {
			return err
		}

		crowdinTranslations, err := c.List(ctx)
		if err != nil {
			return err
		}

		err = c.syncEpisodes(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncSeasons(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncShows(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncSections(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncPages(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncLinks(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncTopics(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncLessons(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncTasks(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncAlternatives(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncAchievements(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncSurveys(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncSurveyQuestions(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncFAQs(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
		err = c.syncFAQCategories(ctx, d, project, directory.ID, crowdinTranslations)
		if err != nil {
			return err
		}
	}
	log.L.Debug().Msg("Translation sync: Done")
	return nil
}

// TranslationSource is an object which contains fields that can be translated
type TranslationSource interface {
	GetCollection() string
	GetItemID() int
	GetLanguage() string
	// GetValues returns a field mapped dictionary with the translation source as value, identifier as key
	GetValues() map[string]string
}

// SaveTranslations stores updated translations from the objects, if they are changed
func (c *Client) SaveTranslations(objects []TranslationSource) error {
	log.L.Debug().Int("count", len(objects)).Msg("Syncing translations with Crowdin")
	for _, projectId := range c.config.ProjectIDs {
		project, err := c.getProject(projectId)
		if err != nil {
			return err
		}
		directory, err := c.getDirectoryForProject(project)
		if err != nil {
			return err
		}
		fileIdByCollection := map[string]int{}
		for _, o := range objects {
			if project.SourceLanguageId != o.GetLanguage() {
				continue
			}
			collection := o.GetCollection()
			fileId, ok := fileIdByCollection[collection]
			if !ok {
				file, _, err := c.getFileForCollection(project, directory.ID, collection)
				if err != nil {
					return err
				}
				fileId = file.ID
				fileIdByCollection[collection] = file.ID
			}
			sourceStrings, err := c.getStrings(project.ID, fileId)
			if err != nil {
				return err
			}
			for field, value := range o.GetValues() {
				if value == "" {
					continue
				}
				identifier := fmt.Sprintf("%s-%d-%s", collection, o.GetItemID(), field)
				s, found := lo.Find(sourceStrings, func(s String) bool {
					return s.Identifier == identifier
				})
				if found {
					if s.Text != value {
						s.Text = value
						log.L.Debug().Str("identifier", s.Identifier).Msg("Updating string")
						_, err := c.setString(project.ID, s)
						if err != nil {
							return err
						}
					}
				} else {
					log.L.Debug().Str("identifier", identifier).Msg("Creating string")
					_, err = c.addString(project.ID, fileId, String{
						FileID:     fileId,
						Identifier: identifier,
						Text:       value,
					})
					if err != nil {
						return err
					}
				}
			}
		}
	}
	log.L.Debug().Msg("Saved translations")
	return nil
}
