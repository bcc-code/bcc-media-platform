package gqlmodel

import (
	"context"
	"fmt"
	"path"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
)

// FileFromSQL converts Assetfile rows to the GQL equvivalents
func FileFromSQL(ctx context.Context, sqlFile sqlc.Assetfile) *File {
	var subLang *Language
	if sqlFile.SubtitleLanguageID.Valid {
		l := Language(sqlFile.SubtitleLanguageID.String)
		subLang = &l
	}

	return &File{
		ID:               fmt.Sprintf("%d", sqlFile.ID),
		URL:              sqlFile.Path, // TODO: Make a full url out of the path
		FileName:         path.Base(sqlFile.Path),
		AudioLanguage:    Language(sqlFile.AudioLanguageID.String),
		SubtitlaLanguage: subLang,
		MimeType:         sqlFile.MimeType,
	}
}
