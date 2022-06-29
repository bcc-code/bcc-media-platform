package crowdin

import (
	"fmt"
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

func New(url string, token string, config ClientConfig) *Client {
	c := resty.New().
		SetBaseURL(url).
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
	req.SetResult(item)
	res, err := req.Post(endpoint)
	if err != nil {
		log.L.Error().Err(err).
			Str("endpoint", endpoint).
			Msg("Failed to create item")
		return
	}
	return *res.Result().(*t)
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

func (client *Client) syncCollection(d *directus.Handler, project Project, directoryId int, collection string, translations []simpleTranslation) {
	log.L.Debug().Int("project", project.ID).Str("collection", collection).Msg("Syncing collection")
	projectId := project.ID
	language := project.SourceLanguageId
	sourceTranslations := lo.Filter(translations, func(t simpleTranslation, _ int) bool {
		return t.Language == language // && t.IsPrimary == true
	})
	files := client.getFiles(project.ID, directoryId)
	var file File
	if len(files) == 0 {
		_, err := client.createFile(project.ID, directoryId, collection, convertTsToStrings(sourceTranslations, collection))
		if err != nil {
			log.L.Error().Err(err).Str("collection", collection).Msg("failed to create file for collection")
		}
		return
	} else {
		file = files[0]
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
		client.addStrings(project.ID, file.ID, missingStrings)
	}

	var queuedTranslations []simpleTranslation

	pushTranslations := func(force bool) {
		if length := len(queuedTranslations); length > 100 || (force && length > 0) {
			log.L.Debug().Str("collection", collection).Msgf("Pushing %d translations to database", length)
			switch collection {
			case "episodes":
				d.SaveTranslations(lo.Map(queuedTranslations, func(t simpleTranslation, _ int) directus.DSItem {
					return directus.EpisodesTranslation{
						Translation: directus.Translation{
							ID:            t.ID,
							LanguagesCode: t.Language,
							Title:         t.Title,
							Description:   t.Description,
						},
						EpisodesID: t.ParentID,
					}
				}))
			case "seasons":
				d.SaveTranslations(lo.Map(queuedTranslations, func(t simpleTranslation, _ int) directus.DSItem {
					return directus.SeasonsTranslation{
						Translation: directus.Translation{
							ID:            t.ID,
							LanguagesCode: t.Language,
							Title:         t.Title,
							Description:   t.Description,
						},
						SeasonsID: t.ParentID,
					}
				}))
			case "shows":
				d.SaveTranslations(lo.Map(queuedTranslations, func(t simpleTranslation, _ int) directus.DSItem {
					return directus.ShowsTranslation{
						Translation: directus.Translation{
							ID:            t.ID,
							LanguagesCode: t.Language,
							Title:         t.Title,
							Description:   t.Description,
						},
						ShowsID: t.ParentID,
					}
				}))
			}
			queuedTranslations = nil
		}
	}

	for _, language := range project.TargetLanguages {
		log.L.Debug().Str("language", language.ID).Msg("Syncing translations.")

		existingTranslations := lo.Filter(translations, func(t simpleTranslation, _ int) bool {
			return t.Language == language.ID
		})

		log.L.Debug().Msgf("Found %d existing translations", len(existingTranslations))

		ts := client.getTranslations(projectId, file.ID, language.ID)

		log.L.Debug().Msgf("Retrieved %d translations", len(ts))

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
		queuedTranslations = append(queuedTranslations, lo.Map(lo.Filter(items, func(i *simpleTranslation, _ int) bool {
			return i.Changed
		}), func(i *simpleTranslation, _ int) simpleTranslation {
			return *i
		})...)
		pushTranslations(false)
	}
	pushTranslations(true)
}

func (client *Client) syncEpisodes(d *directus.Handler, project Project, directoryId int) {
	translations := lo.Map(d.ListEpisodeTranslations("", false), func(t directus.EpisodesTranslation, _ int) simpleTranslation {
		return simpleTranslation{
			ID:          t.ID,
			Description: t.Description,
			Title:       t.Title,
			Language:    t.LanguagesCode,
			ParentID:    t.EpisodesID,
		}
	})
	client.syncCollection(d, project, directoryId, "episodes", translations)
}

func (client *Client) syncSeasons(d *directus.Handler, project Project, directoryId int) {
	translations := lo.Map(d.ListSeasonTranslations("", false), func(t directus.SeasonsTranslation, _ int) simpleTranslation {
		return simpleTranslation{
			ID:          t.ID,
			Description: t.Description,
			Title:       t.Title,
			Language:    t.LanguagesCode,
			ParentID:    t.SeasonsID,
		}
	})
	client.syncCollection(d, project, directoryId, "seasons", translations)
}

func (client *Client) syncShows(d *directus.Handler, project Project, directoryId int) {
	translations := lo.Map(d.ListShowTranslations("", false), func(t directus.ShowsTranslation, _ int) simpleTranslation {
		return simpleTranslation{
			ID:          t.ID,
			Description: t.Description,
			Title:       t.Title,
			Language:    t.LanguagesCode,
			ParentID:    t.ShowsID,
		}
	})
	client.syncCollection(d, project, directoryId, "shows", translations)
}

func (client *Client) getProject(projectId int) Project {
	return getItem[Project](client, "projects", projectId)
}

func (client *Client) Sync(d *directus.Handler) {
	projectIds := client.config.ProjectIDs
	for _, id := range projectIds {
		project := client.getProject(id)
		directories := client.getDirectories(project.ID)

		var directory *Directory
		for _, d := range directories {
			if d.Name == "Content" {
				directory = &d
			}
		}
		if directory == nil {
			directory = &Directory{
				Name: "Content",
			}
			createItem(client, fmt.Sprintf("projects/%d/directories", project.ID), *directory)
		}

		log.L.Debug().Msgf("Retrieved %d directories", len(directories))
		client.syncEpisodes(d, project, directory.ID)
		client.syncSeasons(d, project, directory.ID)
		client.syncShows(d, project, directory.ID)
	}
}
