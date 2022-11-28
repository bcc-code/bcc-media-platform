package crowdin

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"regexp"
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

// Config for the client
type Config struct {
	Token      string
	ProjectIDs []int
}

// Client for crowdin interactions
type Client struct {
	c      *resty.Client
	du     *directus.Handler
	config Config
	q      *sqlc.Queries
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
func New(config Config, directusHandler *directus.Handler, queries *sqlc.Queries) *Client {
	c := resty.New().
		SetBaseURL("https://api.crowdin.com/api/v2/").
		SetAuthToken(config.Token)
	return &Client{
		du:     directusHandler,
		c:      c,
		config: config,
		q:      queries,
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
	ID          int
	ParentID    int
	Title       string
	Description string
	Language    string
	Changed     bool
}

func convertTsToStrings(ts []simpleTranslation, prefix string) []String {
	return lo.Reduce(ts, func(stringObjects []String, t simpleTranslation, _ int) []String {
		var values = map[string]string{
			"title":       t.Title,
			"description": t.Description,
		}
		for key, value := range values {
			if value != "" {
				stringObjects = append(stringObjects, String{
					Identifier: fmt.Sprintf("%s-%d-%s", prefix, t.ParentID, key),
					Text:       value,
				})
			}
		}
		return stringObjects
	}, []String{})
}

func toDSItems(collection string, translations []simpleTranslation) []directus.DSItem {
	switch collection {
	case "episodes":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			return directus.EpisodesTranslation{
				Translation: directus.Translation{
					ID:            t.ID,
					LanguagesCode: t.Language,
					Title:         t.Title,
					Description:   t.Description,
				},
				EpisodesID: t.ParentID,
			}
		})
	case "seasons":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			return directus.SeasonsTranslation{
				Translation: directus.Translation{
					ID:            t.ID,
					LanguagesCode: t.Language,
					Title:         t.Title,
					Description:   t.Description,
				},
				SeasonsID: t.ParentID,
			}
		})
	case "shows":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			return directus.ShowsTranslation{
				Translation: directus.Translation{
					ID:            t.ID,
					LanguagesCode: t.Language,
					Title:         t.Title,
					Description:   t.Description,
				},
				ShowsID: t.ParentID,
			}
		})
	case "sections":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			return directus.SectionsTranslation{
				Translation: directus.Translation{
					ID:            t.ID,
					LanguagesCode: t.Language,
					Title:         t.Title,
					Description:   t.Description,
				},
				SectionsID: t.ParentID,
			}
		})
	default:
		return nil
	}
}

var directoryCache = cache.New[int, Directory]()

func (client *Client) getDirectoryForProject(project Project) (d Directory, err error) {
	if dir, ok := directoryCache.Get(project.ID); ok {
		return dir, nil
	}

	directories, err := client.getDirectories(project.ID)
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
		dir, err := createItem(client, fmt.Sprintf("projects/%d/directories", project.ID), Directory{
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

func (client *Client) getFileForCollection(project Project, directoryId int, collection string) (file File, err error) {
	files, err := client.getFiles(project.ID, directoryId)
	if err != nil {
		return
	}
	found := false
	if len(files) > 0 {
		for _, f := range files {
			if f.Title == collection {
				found = true
				file = f
			}
		}
	}
	if !found {
		err = merry.New("Couldn't find file for collection. Do an initial sync to create the file.")
	}
	return
}

func prepareStr(source string) string {
	reg := regexp.MustCompile("[^a-zA-Z\\d]+")
	return reg.ReplaceAllString(source, "")
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

func (client *Client) syncCollection(ctx context.Context, d *directus.Handler, project Project, directoryId int, collection string, translationFactory func(ctx context.Context, language string) ([]simpleTranslation, error)) error {
	log.L.Debug().Int("project", project.ID).Str("collection", collection).Msg("Syncing collection")
	projectId := project.ID
	language := project.SourceLanguageId
	sourceTranslations, err := translationFactory(ctx, language)
	if err != nil {
		return err
	}
	file, err := client.getFileForCollection(project, directoryId, collection)
	if err != nil {
		log.L.Debug().Msg("Creating file")
		_, err := client.createFile(project.ID, directoryId, collection, convertTsToStrings(sourceTranslations, collection))
		if err != nil {
			log.L.Error().Err(err).Str("collection", collection).Msg("failed to create file for collection")
		}
		return err
	}

	dbStrings := convertTsToStrings(sourceTranslations, collection)

	fileStrings, err := client.getStrings(projectId, file.ID)
	if err != nil {
		return err
	}
	stringsById := lo.Reduce(fileStrings, func(dict map[int]String, s String, _ int) map[int]String {
		dict[s.ID] = s
		return dict
	}, map[int]String{})

	var missingStrings []String
	var editStrings []String
	for _, str := range dbStrings {
		if s, found := lo.Find(fileStrings, func(s String) bool {
			return s.Identifier == str.Identifier
		}); !found {
			log.L.Debug().Str("identifier", str.Identifier).Msg("String not found, updating")
			missingStrings = append(missingStrings, str)
		} else {
			if strings.TrimSpace(s.Text) != strings.TrimSpace(str.Text) {
				log.L.Debug().Str("source", str.Text).Str("value", s.Text).Msg("Texts are not identical, updating")
				s.Text = str.Text
				editStrings = append(editStrings, s)
			}
		}
	}

	if len(missingStrings) > 0 {
		for _, str := range missingStrings {
			log.L.Debug().Str("identifier", str.Identifier).Msg("Adding missing string")
			_, err = client.addString(project.ID, file.ID, str)
			if err != nil {
				return err
			}
		}
	}
	if len(editStrings) > 0 {
		for _, str := range editStrings {
			log.L.Debug().Str("identifier", str.Identifier).Msg("Editing string")
			_, err = client.setString(project.ID, str)
			if err != nil {
				return err
			}
		}
	}

	var queuedTranslations []simpleTranslation

	pushTranslations := func(force bool) error {
		if length := len(queuedTranslations); length > 100 || (force && length > 0) {
			log.L.Debug().Str("collection", collection).Int("count", length).Msg("Pushing translations to database")
			err = d.SaveTranslations(ctx, toDSItems(collection, queuedTranslations))
			if err != nil {
				return err
			}
			queuedTranslations = nil
		}
		return nil
	}

	for _, language := range project.TargetLanguages {
		log.L.Debug().Str("language", language.ID).Msg("Syncing translations.")

		lan := dbLanguage(language.ID)

		existingTranslations, err := translationFactory(ctx, lan)

		log.L.Debug().Int("count", len(existingTranslations)).Msg("Found existing translations")

		approvals, err := client.getApprovals(projectId, file.ID, language.ID)
		if err != nil {
			return err
		}

		ts, err := client.getTranslations(projectId, file.ID, language.ID)
		if err != nil {
			return err
		}

		log.L.Debug().Int("count", len(ts)).Msg("Retrieved translations")

		var items []*simpleTranslation
		for _, t := range ts {
			s, ok := stringsById[t.StringID]
			if !ok {
				continue
			}
			_, approved := lo.Find(approvals, func(a Approval) bool {
				return a.TranslationID == t.TranslationID
			})
			if !approved {
				continue
			}

			parts := strings.Split(s.Identifier, "-")
			if len(parts) != 3 {
				continue
			}
			objectId, _ := strconv.ParseInt(parts[1], 10, 64)
			field := parts[2]
			item, found := lo.Find(items, func(i *simpleTranslation) bool {
				return i.ParentID == int(objectId)
			})
			if !found {
				existingItem, found := lo.Find(existingTranslations, func(i simpleTranslation) bool {
					return i.ParentID == int(objectId)
				})
				if !found {
					item = &simpleTranslation{
						Language: dbLanguage(language.ID),
						ParentID: int(objectId),
					}
				} else {
					item = &existingItem
				}
				items = append(items, item)
			}
			value := dbString(t.Text)
			if value == "" {
				continue
			}
			switch field {
			case "title":
				if !strEqual(item.Title, value) {
					item.Title = value
					item.Changed = true
				}
			case "description":
				if !strEqual(item.Description, value) {
					item.Description = value
					item.Changed = true
				}
			}
		}
		queuedTranslations = append(queuedTranslations, lo.Map(
			lo.Filter(
				items,
				func(i *simpleTranslation, _ int) bool {
					return i.Changed && lo.SomeBy(sourceTranslations, func(t simpleTranslation) bool {
						return t.ParentID == i.ParentID
					})
				},
			),
			func(i *simpleTranslation, _ int) simpleTranslation {
				return *i
			},
		)...)
		err = pushTranslations(true)
		if err != nil {
			return err
		}
	}
	err = pushTranslations(true)
	if err != nil {
		return err
	}
	return nil
}

type hasStatus interface {
	UID() int
	GetStatus() common.Status
}

func (client *Client) syncEpisodes(ctx context.Context, d *directus.Handler, project Project, directoryId int) error {
	return client.syncCollection(ctx, d, project, directoryId, "episodes", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := client.q.ListEpisodeTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(
			ts,
			func(t sqlc.ListEpisodeTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
					ID:          int(t.ID),
					Description: t.Description.ValueOrZero(),
					Title:       t.Title.ValueOrZero(),
					Language:    t.LanguagesCode,
					ParentID:    int(t.ParentID),
				}
			}), nil
	})
}

func (client *Client) syncSeasons(ctx context.Context, d *directus.Handler, project Project, directoryId int) error {
	return client.syncCollection(ctx, d, project, directoryId, "seasons", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := client.q.ListSeasonTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListSeasonTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID:          int(t.ID),
				Description: t.Description.ValueOrZero(),
				Title:       t.Title.ValueOrZero(),
				Language:    t.LanguagesCode,
				ParentID:    int(t.ParentID),
			}
		}), nil
	})
}

func (client *Client) syncShows(ctx context.Context, d *directus.Handler, project Project, directoryId int) error {
	return client.syncCollection(ctx, d, project, directoryId, "shows", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := client.q.ListShowTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListShowTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID:          int(t.ID),
				Description: t.Description.ValueOrZero(),
				Title:       t.Title.ValueOrZero(),
				Language:    t.LanguagesCode,
				ParentID:    int(t.ParentID),
			}
		}), nil
	})
}

func (client *Client) syncSections(ctx context.Context, d *directus.Handler, project Project, directoryId int) error {
	return client.syncCollection(ctx, d, project, directoryId, "sections", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := client.q.ListSectionTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListSectionTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID:          int(t.ID),
				Description: t.Description.ValueOrZero(),
				Title:       t.Title.ValueOrZero(),
				Language:    t.LanguagesCode,
				ParentID:    int(t.ParentID),
			}
		}), nil
	})
}

var projectCache = cache.New[int, Project]()

func (client *Client) getProject(projectId int) (i Project, err error) {
	if p, ok := projectCache.Get(projectId); ok {
		return p, nil
	}
	i, err = getItem[Project](client, "projects", projectId)
	if err != nil {
		return
	}
	projectCache.Set(projectId, i, cache.WithExpiration(time.Minute*5))
	return
}

// Sync synchronizes translations from Directus to Crowdin
func (client *Client) Sync(ctx context.Context, d *directus.Handler) error {
	log.L.Debug().Msg("Translation sync: Started")
	projectIds := client.config.ProjectIDs
	for _, id := range projectIds {
		project, err := client.getProject(id)
		if err != nil {
			return err
		}
		directory, err := client.getDirectoryForProject(project)
		if err != nil {
			return err
		}

		err = client.syncEpisodes(ctx, d, project, directory.ID)
		if err != nil {
			return err
		}
		err = client.syncSeasons(ctx, d, project, directory.ID)
		if err != nil {
			return err
		}
		err = client.syncShows(ctx, d, project, directory.ID)
		if err != nil {
			return err
		}
		err = client.syncSections(ctx, d, project, directory.ID)
	}
	log.L.Debug().Msg("Translation sync: Done")
	return nil
}

// TranslationSource is an object which contains fields that can be translated
type TranslationSource interface {
	GetCollection() string
	GetItemID() int
	GetSourceLanguage() string
	// GetValues returns a field mapped dictionary with the translation source as value, identifier as key
	GetValues() map[string]string
}

// SaveTranslations stores updated translations from the objects, if they are changed
func (client *Client) SaveTranslations(objects []TranslationSource) error {
	log.L.Debug().Int("count", len(objects)).Msg("Syncing translations with Crowdin")
	for _, projectId := range client.config.ProjectIDs {
		project, err := client.getProject(projectId)
		if err != nil {
			return err
		}
		directory, err := client.getDirectoryForProject(project)
		if err != nil {
			return err
		}
		fileIdByCollection := map[string]int{}
		for _, o := range objects {
			if project.SourceLanguageId != o.GetSourceLanguage() {
				continue
			}
			collection := o.GetCollection()
			fileId, ok := fileIdByCollection[collection]
			if !ok {
				file, err := client.getFileForCollection(project, directory.ID, collection)
				if err != nil {
					return err
				}
				fileId = file.ID
				fileIdByCollection[collection] = file.ID
			}
			sourceStrings, err := client.getStrings(project.ID, fileId)
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
						_, err := client.setString(project.ID, s)
						if err != nil {
							return err
						}
					}
				} else {
					log.L.Debug().Str("identifier", identifier).Msg("Creating string")
					_, err = client.addString(project.ID, fileId, String{
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
