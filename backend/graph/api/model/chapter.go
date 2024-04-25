package model

import (
	"context"
	"fmt"
	"strings"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

func ChapterFrom(ctx context.Context, tm *common.TimedMetadata, loaders *common.BatchLoaders) *Chapter {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	title := tm.Title.Get(languages)
	phrase, _ := loaders.PhraseLoader.Get(ctx, tm.ChapterType.Value)
	emptyTitle := title == ""
	if emptyTitle && phrase != nil {
		title = phrase.Value.Get(languages)
	}

	switch tm.ChapterType {
	case common.ChapterTypeSong, common.ChapterTypeSingAlong:
		if !tm.SongID.Valid {
			break
		}
		song, _ := loaders.SongLoader.Get(ctx, tm.SongID.UUID)
		if song == nil {
			break
		}
		if emptyTitle {
			if phrase != nil {
				title = fmt.Sprintf("%s - %s", phrase.Value.Get(languages), song.Title.Get(languages))
			} else {
				title = song.Title.Get(languages)
			}
		} else {
			title = strings.Replace(title, "{{song.title}}", song.Title.Get(languages), -1)
		}
	case common.ChapterTypeSpeech, common.ChapterTypeAppeal, common.ChapterTypeTestimony:
		if len(tm.PersonIDs) != 1 {
			break
		}
		personID := tm.PersonIDs[0]
		person, _ := loaders.PersonLoader.Get(ctx, personID)
		if person == nil {
			break
		}
		if emptyTitle {
			if phrase != nil {
				title = fmt.Sprintf("%s - %s", phrase.Value.Get(languages), person.Name)
			} else {
				title = person.Name
			}
		} else {
			title = strings.Replace(title, "{{person.name}}", person.Name, -1)
		}
	}

	return &Chapter{
		ID:          tm.ID.String(),
		Title:       title,
		Description: tm.Description.GetValueOrNil(languages),
		Start:       int(tm.Timestamp),
	}
}
