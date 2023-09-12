package crowdin

import (
	"context"
	"strings"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
)

// TranslationHandler handles translations
type TranslationHandler[T any, TUpdate any] struct {
	Collection      string
	Fetch           func(ctx context.Context, language string) ([]T, error)
	ConvertToUpdate func(item SimpleTranslation) TUpdate
	Save            func(ctx context.Context, item TUpdate) error
	GetContext      func(identifier string) string
}

// NewTranslationHandler creates a handler from functions
func NewTranslationHandler[T any, TUpdate any](
	collection string,
	fetch func(ctx context.Context, language string) ([]T, error),
	convertToUpdate func(item SimpleTranslation) TUpdate,
	save func(ctx context.Context, item TUpdate) error,
	getContext func(identifier string) string) TranslationHandler[T, TUpdate] {
	return TranslationHandler[T, TUpdate]{
		Collection:      collection,
		Fetch:           fetch,
		ConvertToUpdate: convertToUpdate,
		Save:            save,
		GetContext:      getContext,
	}
}

// Options are common options for every translation collection
type Options struct {
	Project      Project
	DirectoryID  int
	Translations []Translation
}

func syncCollection[T any, TUpdate any](
	ctx context.Context,
	c *Client,
	options Options,
	handler TranslationHandler[T, TUpdate],
) error {
	project := options.Project
	directoryID := options.DirectoryID
	collection := handler.Collection

	l := log.L.With().Int("project", project.ID).Str("collection", collection).Logger()
	l.Debug().Msg("Syncing collection")

	projectId := project.ID
	language := project.SourceLanguageId

	translationFactory := func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		return dbToSimple(ctx, language, handler.Fetch)
	}

	sourceTranslations, err := translationFactory(ctx, language)
	if err != nil {
		return err
	}
	file, found, err := c.getFileForCollection(project, directoryID, collection)
	if err != nil {
		return err
	}
	if !found {
		l.Debug().Msg("Creating file (if not empty)")
		if c.readonly || len(sourceTranslations) <= 0 {
			return nil
		}
		_, err := c.createFile(project.ID, directoryID, collection, convertTsToStrings(sourceTranslations, collection, handler.GetContext))
		if err != nil {
			l.Error().Err(err).Msg("failed to create file for collection")
		}
		return err
	}

	dbStrings := convertTsToStrings(sourceTranslations, collection, handler.GetContext)

	fileStrings, err := c.getStrings(projectId, file.ID)
	if err != nil {
		return err
	}

	var missingStrings []String
	var editStrings []String
	var deleteStrings []String
	for _, str := range dbStrings {
		if s, found := lo.Find(fileStrings, func(s String) bool {
			return s.Identifier == str.Identifier
		}); !found {
			l.Debug().Str("identifier", str.Identifier).Msg("String not found, updating")
			missingStrings = append(missingStrings, str)
		} else {
			if strings.TrimSpace(s.Text) != strings.TrimSpace(str.Text) || (strings.TrimSpace(str.Context) != "" && strings.TrimSpace(s.Context) != strings.TrimSpace(str.Context)) {
				l.Debug().Str("source", str.Text).Str("value", s.Text).Msg("Texts are not identical, updating")
				s.Text = str.Text
				s.Context = str.Context
				s.IsHidden = str.IsHidden
				editStrings = append(editStrings, s)
			}
		}
	}
	for _, str := range fileStrings {
		if _, found := lo.Find(dbStrings, func(s String) bool {
			return s.Identifier == str.Identifier
		}); !found && !str.IsHidden {
			deleteStrings = append(deleteStrings, str)
		}
	}

	if len(missingStrings) > 0 {
		for _, str := range missingStrings {
			l.Debug().Str("identifier", str.Identifier).Msg("Adding missing string")
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
			l.Debug().Str("identifier", str.Identifier).Msg("Editing string")
			if c.readonly {
				continue
			}
			_, err = c.setString(project.ID, str)
			if err != nil {
				return err
			}
		}
	}
	if len(deleteStrings) > 0 {
		l.Debug().Int("count", len(deleteStrings)).Strs("identifiers", lo.Map(deleteStrings, func(i String, _ int) string {
			return i.Identifier
		})).Msg("Hiding strings")
		err = c.hideStrings(project.ID, deleteStrings)
		if err != nil {
			return err
		}
	}

	var queuedTranslations []SimpleTranslation

	pushTranslations := func(force bool) error {
		if length := len(queuedTranslations); length > 100 || (force && length > 0) {
			l.Debug().Int("count", length).Msg("Pushing translations to database")
			if !c.readonly {
				for _, t := range queuedTranslations {
					err = handler.Save(ctx, handler.ConvertToUpdate(t))
					if err != nil {
						return err
					}
				}
			}
			queuedTranslations = nil
		}
		return nil
	}

	for _, language := range project.TargetLanguages {
		lan := dbLanguage(language.ID)

		existingTranslations, err := translationFactory(ctx, lan)

		ts := lo.Filter(options.Translations, func(i Translation, _ int) bool {
			return i.Collection == collection && i.Language == lan
		})

		var items []*SimpleTranslation
		for _, t := range ts {
			if t.Field == "extra_description" {
				continue
			}
			_, found = lo.Find(sourceTranslations, func(i SimpleTranslation) bool {
				return i.ParentID == t.ID
			})
			if !found {
				continue
			}
			item, found := lo.Find(items, func(i *SimpleTranslation) bool {
				return i.ParentID == t.ID
			})
			if !found {
				existingItem, found := lo.Find(existingTranslations, func(i SimpleTranslation) bool {
					return i.ParentID == t.ID
				})
				if !found {
					item = &SimpleTranslation{
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
				func(i *SimpleTranslation, _ int) bool {
					return i.Changed && lo.SomeBy(sourceTranslations, func(t SimpleTranslation) bool {
						return t.ParentID == i.ParentID
					})
				},
			),
			func(i *SimpleTranslation, _ int) SimpleTranslation {
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
