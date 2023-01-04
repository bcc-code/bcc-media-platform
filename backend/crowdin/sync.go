package crowdin

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	"strings"
)

func (c *Client) syncCollection(
	ctx context.Context,
	d *directus.Handler,
	project Project,
	directoryId int,
	collection string,
	translationFactory func(ctx context.Context, language string) ([]simpleTranslation, error),
	crowdinTranslations []Translation,
	contextFactory func(identifier string) string,
	toDSItems func(items []simpleTranslation) []directus.DSItem,
	deleteTranslations func(ctx context.Context, keys []string) error,
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
		if c.readonly {
			return nil
		}
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
			if c.readonly {
				continue
			}
			_, err = c.addString(project.ID, file.ID, str)
			if err != nil {
				return err
			}
		}
	}
	if len(editStrings) > 0 {
		for _, str := range editStrings {
			log.L.Debug().Str("identifier", str.Identifier).Msg("Editing string")
			if c.readonly {
				continue
			}
			_, err = c.setString(project.ID, str)
			if err != nil {
				return err
			}
		}
		if deleteTranslations != nil {
			err = deleteTranslations(ctx, lo.Map(editStrings, func(i String, _ int) string {
				_, key, _ := partsFromIdentifier(i.Identifier)
				return key
			}))
			if err != nil {
				return err
			}
		}
	}

	var queuedTranslations []simpleTranslation

	pushTranslations := func(force bool) error {
		if length := len(queuedTranslations); length > 100 || (force && length > 0) {
			log.L.Debug().Str("collection", collection).Int("count", length).Msg("Pushing translations to database")
			if !c.readonly {
				items := toDSItems(queuedTranslations)
				err = d.SaveTranslations(ctx, items)
				if err != nil {
					return err
				}
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
			if t.Field == "extra_description" {
				continue
			}
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
						Values:   map[string]string{},
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
