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

func getItems[t any](client *Client, endpoint string) (items []t) {
	req := client.c.R()
	req.SetResult(Result[[]Object[t]]{})
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

func getStringsFromFile(client *Client, projectId int, fileId int) (stringsById map[int]String) {
	resultLength := 0
	offset := 0
	limit := 100
	stringsById = map[int]String{}

	for {
		strs := getItems[String](client, fmt.Sprintf("projects/%d/strings?fileId=%d&limit=%d&offset=%d", projectId, fileId, limit, offset))

		for _, s := range strs {
			stringsById[s.ID] = s
		}

		resultLength = len(strs)

		if resultLength == limit {
			offset += limit
			continue
		}
		break
	}
	return
}

func getApprovalsForFileAndLanguage(client *Client, projectId int, fileId int, languageId string, offset int, limit int) []Approval {
	req := client.c.R()
	req.SetResult(Result[[]Object[Approval]]{})
	req.SetQueryParams(map[string]string{
		"limit":      strconv.Itoa(limit),
		"offset":     strconv.Itoa(offset),
		"fileId":     strconv.Itoa(fileId),
		"languageId": languageId,
	})
	res, err := req.Get(fmt.Sprintf("projects/%d/approvals", projectId))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve approvals")
		return nil
	}
	return lo.Map(res.Result().(*Result[[]Object[Approval]]).Data, func(i Object[Approval], _ int) Approval {
		return i.Data
	})
}

type simpleTranslation struct {
	ID          int
	ParentID    int
	Title       string
	Description string
	Language    string
	Changed     bool
}

func (client *Client) syncCollection(d *directus.Handler, project Project, directoryId int, collection string, translations []simpleTranslation) {
	log.L.Debug().Int("project", project.ID).Str("collection", collection).Msg("Syncing collection")
	projectId := project.ID
	language := project.SourceLanguageId
	files := getItems[File](client, fmt.Sprintf("projects/%d/files?filter=%s", projectId, collection))
	var file File
	if len(files) == 0 {
		file = createItem(client, fmt.Sprintf("projects/%d/files", projectId), File{
			Name:        fmt.Sprintf("%s.csv", collection),
			Title:       collection,
			DirectoryID: directoryId,
		})
	} else {
		file = files[0]
	}
	sourceTranslations := lo.Filter(translations, func(t simpleTranslation, _ int) bool {
		return t.Language == language // && t.IsPrimary == true
	})
	missingTranslationIdentifiers := lo.Reduce(sourceTranslations, func(ids []string, t simpleTranslation, _ int) []string {
		ids = append(ids, fmt.Sprintf("%s-%d-%s", collection, t.ParentID, "title"))
		if t.Description != "" {
			ids = append(ids, fmt.Sprintf("%s-%d-%s", collection, t.ParentID, "description"))
		}
		return ids
	}, []string{})

	stringsById := getStringsFromFile(client, projectId, file.ID)

	for _, str := range stringsById {
		missingTranslationIdentifiers = lo.Filter(missingTranslationIdentifiers, func(s string, _ int) bool {
			return s != str.Identifier
		})
	}

	if len(missingTranslationIdentifiers) > 0 {
		for _, identifier := range missingTranslationIdentifiers {
			parts := strings.Split(identifier, "-")
			if len(parts) != 3 {
				continue
			}
			objectId, _ := strconv.ParseInt(parts[1], 10, 64)
			field := parts[2]
			translation, found := lo.Find(sourceTranslations, func(t simpleTranslation) bool {
				return t.ParentID == int(objectId)
			})
			if !found {
				continue
			}
			var text string
			switch field {
			case "title":
				text = translation.Title
			case "description":
				text = translation.Description
			}
			if text != "" {
				createItem(client, fmt.Sprintf("projects/%d/strings", projectId), String{
					FileID:     file.ID,
					Text:       text,
					Identifier: identifier,
				})
			}
		}
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
		offset := 0
		limit := 100

		existingTranslations := lo.Filter(translations, func(t simpleTranslation, _ int) bool {
			return t.Language == language.ID
		})

		log.L.Debug().Msgf("Found %d existing translations", len(existingTranslations))

		var approvals []Approval

		for {
			as := getApprovalsForFileAndLanguage(client, project.ID, file.ID, language.ID, offset, limit)

			approvals = append(approvals, as...)

			if len(as) == limit {
				offset += limit
				continue
			}
			break
		}

		log.L.Debug().Msgf("Retrieved %d approvals", len(approvals))
		if len(approvals) == 0 {
			continue
		}

		ts := getItems[Translation](client, fmt.Sprintf("projects/%d/languages/%s/translations?fileId=%d", project.ID, language.ID, file.ID))

		log.L.Debug().Msgf("Retrieved %d translations", len(ts))

		var items []simpleTranslation
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
			item, found := lo.Find(items, func(i simpleTranslation) bool {
				return i.ParentID == int(objectId)
			})
			if !found {
				item, found = lo.Find(existingTranslations, func(i simpleTranslation) bool {
					return i.ParentID == int(objectId)
				})
				if !found {
					item = simpleTranslation{
						Language: language.ID,
						ParentID: int(objectId),
					}
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
		queuedTranslations = append(queuedTranslations, lo.Filter(items, func(i simpleTranslation, _ int) bool {
			return i.Changed
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

func (client *Client) Sync(d *directus.Handler) {
	projectIds := client.config.ProjectIDs
	for _, id := range projectIds {
		project := getItem[Project](client, "projects", id)
		directories := getItems[Directory](client, fmt.Sprintf("projects/%d/directories", project.ID))

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
