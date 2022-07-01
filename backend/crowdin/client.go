package crowdin

import (
	"context"
	"fmt"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/go-resty/resty/v2"
	"github.com/samber/lo"
	"strconv"
	"strings"
)

type ClientConfig struct {
	ProjectIDs []int
}

type Client struct {
	c      *resty.Client
	config ClientConfig
}

func New(token string, config ClientConfig) *Client {
	c := resty.New().
		SetBaseURL("https://api.crowdin.com/api/v2/").
		SetAuthToken(token)
	return &Client{
		c,
		config,
	}
}

func getItem[t any](client *Client, endpoint string, id int) (item t) {
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
	return res.Result().(*Object[t]).Data
}

func getItems[t any](client *Client, endpoint string, limit int, offset int, queryParams map[string]string) (items []t) {
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
	return lo.Map(res.Result().(*Result[[]Object[t]]).Data, func(i Object[t], _ int) t {
		return i.Data
	})
}

func createItem[t any](client *Client, endpoint string, item t) (i t) {
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
	return res.Result().(*Object[t]).Data
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
	return lo.Reduce(ts, func(strings []String, t simpleTranslation, _ int) []String {
		var values = map[string]string{
			"title":       t.Title,
			"description": t.Description,
		}
		for key, value := range values {
			if value != "" {
				strings = append(strings, String{
					Identifier: fmt.Sprintf("%s-%d-%s", prefix, t.ParentID, key),
					Text:       value,
				})
			}
		}
		return strings
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
	default:
		return nil
	}
}

func (client *Client) getDirectoryForProject(project Project) Directory {
	directories := client.getDirectories(project.ID)

	var directory *Directory
	for _, d := range directories {
		if d.Name == "content" {
			directory = &d
		}
	}
	if directory == nil {
		dir := createItem(client, fmt.Sprintf("projects/%d/directories", project.ID), Directory{
			Name: "content",
		})
		directory = &dir
	}

	return *directory
}

func (client *Client) getFileForCollection(project Project, directoryId int, collection string) (file File, err error) {
	files := client.getFiles(project.ID, directoryId)
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

func (client *Client) syncCollection(ctx context.Context, d *directus.Handler, project Project, directoryId int, collection string, translations []simpleTranslation) {
	log.L.Debug().Int("project", project.ID).Str("collection", collection).Msg("Syncing collection")
	projectId := project.ID
	language := project.SourceLanguageId
	sourceTranslations := lo.Filter(translations, func(t simpleTranslation, _ int) bool {
		return t.Language == language // && t.IsPrimary == true
	})
	file, err := client.getFileForCollection(project, directoryId, collection)
	if err != nil {
		log.L.Debug().Msg("Creating file")
		_, err := client.createFile(project.ID, directoryId, collection, convertTsToStrings(sourceTranslations, collection))
		if err != nil {
			log.L.Error().Err(err).Str("collection", collection).Msg("failed to create file for collection")
		}
		return
	}

	dbStrings := convertTsToStrings(translations, collection)

	fileStrings := client.getStrings(projectId, file.ID)
	stringsById := lo.Reduce(fileStrings, func(dict map[int]String, s String, _ int) map[int]String {
		dict[s.ID] = s
		return dict
	}, map[int]String{})

	var missingStrings []String
	for _, str := range dbStrings {
		if _, found := lo.Find(fileStrings, func(s String) bool {
			return s.Identifier == str.Identifier
		}); !found {
			missingStrings = append(missingStrings, str)
		}
	}

	if len(missingStrings) > 0 {
		for _, str := range missingStrings {
			log.L.Debug().Str("identifier", str.Identifier).Msg("Adding missing string")
			client.addString(project.ID, file.ID, str)
		}
	}

	var queuedTranslations []simpleTranslation

	pushTranslations := func(force bool) {
		if length := len(queuedTranslations); length > 100 || (force && length > 0) {
			log.L.Debug().Str("collection", collection).Int("count", length).Msg("Pushing translations to database")
			d.SaveTranslations(ctx, toDSItems(collection, queuedTranslations))
			queuedTranslations = nil
		}
	}

	for _, language := range project.TargetLanguages {
		log.L.Debug().Str("language", language.ID).Msg("Syncing translations.")

		existingTranslations := lo.Filter(translations, func(t simpleTranslation, _ int) bool {
			return t.Language == language.ID
		})

		log.L.Debug().Int("count", len(existingTranslations)).Msg("Found existing translations")

		ts := client.getTranslations(projectId, file.ID, language.ID)

		log.L.Debug().Int("count", len(ts)).Msg("Retrieved translations")

		var items []*simpleTranslation
		for _, t := range ts {
			s, ok := stringsById[t.StringID]
			if !ok {
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
						Language: language.ID,
						ParentID: int(objectId),
					}
				} else {
					item = &existingItem
				}
				items = append(items, item)
			}
			value := t.Text
			if value == "" {
				continue
			}
			switch field {
			case "title":
				if item.Title != value {
					item.Title = value
					item.Changed = true
				}
			case "description":
				if item.Description != value {
					item.Description = value
					item.Changed = true
				}
			}
		}
		queuedTranslations = append(queuedTranslations, lo.Map(
			lo.Filter(
				items,
				func(i *simpleTranslation, _ int) bool {
					return i.Changed
				},
			),
			func(i *simpleTranslation, _ int) simpleTranslation {
				return *i
			},
		)...)
		pushTranslations(false)
	}
	pushTranslations(true)
}

type hasStatus interface {
	UID() int
	GetStatus() string
}

func getPublishedDictionary[t hasStatus](items []t) map[int]bool {
	return lo.Reduce(items, func(dict map[int]bool, i t, _ int) map[int]bool {
		dict[i.UID()] = i.GetStatus() == common.StatusPublished
		return dict
	}, map[int]bool{})
}

func (client *Client) syncEpisodes(ctx context.Context, d *directus.Handler, project Project, directoryId int) {
	published := getPublishedDictionary(d.ListEpisodes(ctx))
	translations := lo.Map(
		lo.Filter(d.ListEpisodeTranslations(ctx, "", false, 0), func(i directus.EpisodesTranslation, _ int) bool {
			return published[i.EpisodesID]
		}),
		func(t directus.EpisodesTranslation, _ int) simpleTranslation {
			return simpleTranslation{
				ID:          t.ID,
				Description: t.Description,
				Title:       t.Title,
				Language:    t.LanguagesCode,
				ParentID:    t.EpisodesID,
			}
		})
	client.syncCollection(ctx, d, project, directoryId, "episodes", translations)
}

func (client *Client) syncSeasons(ctx context.Context, d *directus.Handler, project Project, directoryId int) {
	published := getPublishedDictionary(d.ListSeasons(ctx))
	translations := lo.Map(
		lo.Filter(d.ListSeasonTranslations(ctx, "", false, 0), func(i directus.SeasonsTranslation, _ int) bool {
			return published[i.SeasonsID]
		}),
		func(t directus.SeasonsTranslation, _ int) simpleTranslation {
			return simpleTranslation{
				ID:          t.ID,
				Description: t.Description,
				Title:       t.Title,
				Language:    t.LanguagesCode,
				ParentID:    t.SeasonsID,
			}
		})
	client.syncCollection(ctx, d, project, directoryId, "seasons", translations)
}

func (client *Client) syncShows(ctx context.Context, d *directus.Handler, project Project, directoryId int) {
	published := getPublishedDictionary(d.ListShows(ctx))
	translations := lo.Map(
		lo.Filter(d.ListShowTranslations(ctx, "", false, 0), func(i directus.ShowsTranslation, _ int) bool {
			return published[i.ShowsID]
		}),
		func(t directus.ShowsTranslation, _ int) simpleTranslation {
			return simpleTranslation{
				ID:          t.ID,
				Description: t.Description,
				Title:       t.Title,
				Language:    t.LanguagesCode,
				ParentID:    t.ShowsID,
			}
		})
	client.syncCollection(ctx, d, project, directoryId, "shows", translations)
}

func (client *Client) getProject(projectId int) Project {
	// TODO: Implement some kind of caching here
	return getItem[Project](client, "projects", projectId)
}

func (client *Client) Sync(ctx context.Context, d *directus.Handler) {
	log.L.Debug().Msg("Translation sync: Started")
	projectIds := client.config.ProjectIDs
	for _, id := range projectIds {
		project := client.getProject(id)
		directory := client.getDirectoryForProject(project)

		client.syncEpisodes(ctx, d, project, directory.ID)
		client.syncSeasons(ctx, d, project, directory.ID)
		client.syncShows(ctx, d, project, directory.ID)
	}
	log.L.Debug().Msg("Translation sync: Done")
}

type TranslationSource interface {
	GetCollection() string
	GetItemID() int
	GetSourceLanguage() string
	GetValues() map[string]string
}

func (client *Client) SaveTranslations(objects []TranslationSource) error {
	log.L.Debug().Int("count", len(objects)).Msg("Syncing translations with Crowdin")
	for _, projectId := range client.config.ProjectIDs {
		project := client.getProject(projectId)
		directory := client.getDirectoryForProject(project)
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
			sourceStrings := client.getStrings(project.ID, fileId)
			for field, value := range o.GetValues() {
				identifier := fmt.Sprintf("%s-%d-%s", collection, o.GetItemID(), field)
				s, found := lo.Find(sourceStrings, func(s String) bool {
					return s.Identifier == identifier
				})
				if found {
					if s.Text != value {
						s.Text = value
						log.L.Debug().Str("identifier", s.Identifier).Msg("Updating string")
						client.setString(project.ID, s)
					}
				} else {
					log.L.Debug().Str("identifier", identifier).Msg("Creating string")
					client.addString(project.ID, fileId, String{
						FileID:     fileId,
						Identifier: identifier,
						Text:       value,
					})
				}
			}
		}
	}
	log.L.Debug().Msg("Saved translations")
	return nil
}
