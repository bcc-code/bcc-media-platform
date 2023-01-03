package crowdin

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/google/uuid"
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

// Fields
const (
	TitleField       = "title"
	DescriptionField = "description"
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

func toDSItems(collection string, translations []simpleTranslation) []directus.DSItem {
	switch collection {
	case "episodes":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.EpisodesTranslation{
				Translation: directus.Translation{
					ID:            utils.AsInt(t.ID),
					LanguagesCode: t.Language,
					Title:         ti,
					Description:   de,
				},
				EpisodesID: utils.AsInt(t.ParentID),
			}
		})
	case "seasons":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.SeasonsTranslation{
				Translation: directus.Translation{
					ID:            utils.AsInt(t.ID),
					LanguagesCode: t.Language,
					Title:         ti,
					Description:   de,
				},
				SeasonsID: utils.AsInt(t.ParentID),
			}
		})
	case "shows":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.ShowsTranslation{
				Translation: directus.Translation{
					ID:            utils.AsInt(t.ID),
					LanguagesCode: t.Language,
					Title:         ti,
					Description:   de,
				},
				ShowsID: utils.AsInt(t.ParentID),
			}
		})
	case "sections":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.SectionsTranslation{
				Translation: directus.Translation{
					ID:            utils.AsInt(t.ID),
					LanguagesCode: t.Language,
					Title:         ti,
					Description:   de,
				},
				SectionsID: utils.AsInt(t.ParentID),
			}
		})
	case "pages":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.PagesTranslation{
				Translation: directus.Translation{
					ID:            utils.AsInt(t.ID),
					LanguagesCode: t.Language,
					Title:         ti,
					Description:   de,
				},
				PagesID: utils.AsInt(t.ParentID),
			}
		})
	case "studytopics":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.StudyTopicsTranslation{
				ID:            t.ID,
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
				StudyTopicsID: t.ParentID,
			}
		})
	case "lessons":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.LessonsTranslation{
				ID:            t.ID,
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
				LessonsID:     t.ParentID,
			}
		})
	case "tasks":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.TasksTranslation{
				ID:            t.ID,
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
				TasksID:       t.ParentID,
			}
		})
	case "questionalternatives":
		return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
			ti, _ := t.Values[TitleField]
			de, _ := t.Values[DescriptionField]
			return directus.QuestionAlternativesTranslation{
				ID:                     t.ID,
				LanguagesCode:          t.Language,
				Title:                  ti,
				Description:            de,
				QuestionAlternativesID: t.ParentID,
			}
		})
	default:
		return nil
	}
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

func (c *Client) syncCollection(
	ctx context.Context,
	d *directus.Handler,
	project Project,
	directoryId int,
	collection string,
	translationFactory func(ctx context.Context, language string) ([]simpleTranslation, error),
	crowdinTranslations []Translation,
	contextFactory func(identifier string) string,
) error {
	log.L.Debug().Int("project", project.ID).Str("collection", collection).Msg("Syncing collection")
	projectId := project.ID
	language := project.SourceLanguageId
	sourceTranslations, err := translationFactory(ctx, language)
	if err != nil {
		return err
	}
	file, found, err := c.getFileForCollection(project, directoryId, collection)
	if err != nil {
		return err
	}
	if !found {
		log.L.Debug().Msg("Creating file")
		_, err := c.createFile(project.ID, directoryId, collection, convertTsToStrings(sourceTranslations, collection, contextFactory))
		if err != nil {
			log.L.Error().Err(err).Str("collection", collection).Msg("failed to create file for collection")
		}
		return err
	}

	dbStrings := convertTsToStrings(sourceTranslations, collection, contextFactory)

	fileStrings, err := c.getStrings(projectId, file.ID)
	if err != nil {
		return err
	}

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
			_, err = c.addString(project.ID, file.ID, str)
			if err != nil {
				return err
			}
		}
	}
	if len(editStrings) > 0 {
		for _, str := range editStrings {
			log.L.Debug().Str("identifier", str.Identifier).Msg("Editing string")
			_, err = c.setString(project.ID, str)
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

		ts := lo.Filter(crowdinTranslations, func(i Translation, _ int) bool {
			return i.Collection == collection && i.Language == lan
		})

		log.L.Debug().Int("count", len(ts)).Msg("Retrieved translations")

		var items []*simpleTranslation
		for _, t := range ts {
			_, found = lo.Find(sourceTranslations, func(i simpleTranslation) bool {
				return i.ParentID == t.ID
			})
			if !found {
				continue
			}
			item, found := lo.Find(items, func(i *simpleTranslation) bool {
				return i.ParentID == t.ID
			})
			if !found {
				existingItem, found := lo.Find(existingTranslations, func(i simpleTranslation) bool {
					return i.ParentID == t.ID
				})
				if !found {
					item = &simpleTranslation{
						Language: dbLanguage(language.ID),
						ParentID: t.ID,
					}
				} else {
					item = &existingItem
				}
				items = append(items, item)
			}
			value := dbString(t.Value)
			if value == "" {
				continue
			}
			val, ok := item.Values[t.Field]
			if !ok || !strEqual(val, value) {
				item.Values[t.Field] = value
				item.Changed = true
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
	UID() string
	GetStatus() common.Status
}

func (c *Client) syncEpisodes(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "episodes", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := c.q.ListEpisodeTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(
			ts,
			func(t sqlc.ListEpisodeTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
					ID: strconv.Itoa(int(t.ID)),
					Values: map[string]string{
						TitleField:       t.Title.ValueOrZero(),
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: t.LanguagesCode,
					ParentID: strconv.Itoa(int(t.ParentID)),
				}
			}), nil
	}, crowdinTranslations, nil)
}

func (c *Client) syncSeasons(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "seasons", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := c.q.ListSeasonTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListSeasonTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID: strconv.Itoa(int(t.ID)),
				Values: map[string]string{
					TitleField:       t.Title.ValueOrZero(),
					DescriptionField: t.Description.ValueOrZero(),
				},
				Language: t.LanguagesCode,
				ParentID: strconv.Itoa(int(t.ParentID)),
			}
		}), nil
	}, crowdinTranslations, nil)
}

func (c *Client) syncShows(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "shows", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := c.q.ListShowTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListShowTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID: strconv.Itoa(int(t.ID)),
				Values: map[string]string{
					TitleField:       t.Title.ValueOrZero(),
					DescriptionField: t.Description.ValueOrZero(),
				},
				Language: t.LanguagesCode,
				ParentID: strconv.Itoa(int(t.ParentID)),
			}
		}), nil
	}, crowdinTranslations, nil)
}

func (c *Client) syncSections(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "sections", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := c.q.ListSectionTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListSectionTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID: strconv.Itoa(int(t.ID)),
				Values: map[string]string{
					TitleField:       t.Title.ValueOrZero(),
					DescriptionField: t.Description.ValueOrZero(),
				},
				Language: t.LanguagesCode,
				ParentID: strconv.Itoa(int(t.ParentID)),
			}
		}), nil
	}, crowdinTranslations, nil)
}

func (c *Client) syncPages(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "pages", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		ts, err := c.q.ListPageTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListPageTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID: strconv.Itoa(int(t.ID)),
				Values: map[string]string{
					TitleField:       t.Title.ValueOrZero(),
					DescriptionField: t.Description.ValueOrZero(),
				},
				Language: t.LanguagesCode.String,
				ParentID: strconv.Itoa(int(t.ParentID.Int64)),
			}
		}), nil
	}, crowdinTranslations, nil)
}

func (c *Client) syncLessons(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "lessons", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListLessonOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListLessonOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title,
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		ts, err := c.q.ListLessonTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListLessonTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID: strconv.Itoa(int(t.ID)),
				Values: map[string]string{
					TitleField:       t.Title.ValueOrZero(),
					DescriptionField: t.Description.ValueOrZero(),
				},
				Language: t.LanguagesCode.String,
				ParentID: t.ParentID.UUID.String(),
			}
		}), nil
	}, crowdinTranslations, nil)
}

func (c *Client) syncTopics(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "studytopics", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListStudyTopicOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListStudyTopicOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title,
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		ts, err := c.q.ListStudyTopicTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListStudyTopicTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID: strconv.Itoa(int(t.ID)),
				Values: map[string]string{
					TitleField:       t.Title.ValueOrZero(),
					DescriptionField: t.Description.ValueOrZero(),
				},
				Language: t.LanguagesCode.String,
				ParentID: t.ParentID.UUID.String(),
			}
		}), nil
	}, crowdinTranslations, nil)
}

func (c *Client) syncTasks(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "tasks", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListTaskOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListTaskOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title.ValueOrZero(),
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		ts, err := c.q.ListTaskTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListTaskTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID: strconv.Itoa(int(t.ID)),
				Values: map[string]string{
					TitleField:       t.Title.ValueOrZero(),
					DescriptionField: t.Description.ValueOrZero(),
				},
				Language: t.LanguagesCode.String,
				ParentID: t.ParentID.UUID.String(),
			}
		}), nil
	}, crowdinTranslations, nil)
}

func (c *Client) syncAlternatives(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	originalTs, err := c.q.ListQuestionAlternativesOriginalTranslations(ctx)
	if err != nil {
		return err
	}

	alts, err := c.q.GetQuestionAlternatives(ctx, lo.Map(originalTs, func(i sqlc.ListQuestionAlternativesOriginalTranslationsRow, _ int) uuid.UUID {
		return i.ID
	}))
	if err != nil {
		return err
	}
	tasks, err := c.q.GetTasks(ctx, lo.Map(alts, func(i common.QuestionAlternative, _ int) uuid.UUID {
		return i.TaskID
	}))
	if err != nil {
		return err
	}
	taskTitles := lo.Reduce(alts, func(m map[string]string, i common.QuestionAlternative, _ int) map[string]string {
		t, f := lo.Find(tasks, func(t common.Task) bool {
			return t.ID == i.TaskID
		})
		if !f {
			return m
		}
		m[i.ID.String()] = t.Title.Get([]string{"no"})
		return m
	}, map[string]string{})

	return c.syncCollection(ctx, d, project, directoryId, "questionalternatives", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			return lo.Map(originalTs, func(t sqlc.ListQuestionAlternativesOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField: t.Title.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		ts, err := c.q.ListAlternativeTranslations(ctx, []string{language})
		if err != nil {
			return nil, err
		}
		return lo.Map(ts, func(t sqlc.ListAlternativeTranslationsRow, _ int) simpleTranslation {
			return simpleTranslation{
				ID: strconv.Itoa(int(t.ID)),
				Values: map[string]string{
					TitleField: t.Title.ValueOrZero(),
				},
				Language: t.LanguagesCode,
				ParentID: t.ParentID.UUID.String(),
			}
		}), nil
	}, crowdinTranslations, func(id string) string {
		if t, ok := taskTitles[id]; ok {
			return "Question: " + t
		}
		return ""
	})
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
