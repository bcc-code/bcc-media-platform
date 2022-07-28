package gqlmodel

import (
	"context"
	"net/url"
	"path"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/samber/lo"
)

// FileFromSQL converts Assetfile rows to the GQL equvivalents
func FileFromSQL(ctx context.Context, sqlFile *sqlc.GetFilesForEpisodesRow) *File {
	var subLang *Language
	if sqlFile.SubtitleLanguageID.Valid {
		l := Language(sqlFile.SubtitleLanguageID.String)
		subLang = &l
	}

	return &File{
		ID:               strconv.Itoa(int(sqlFile.ID)),
		URL:              sqlFile.Path, // TODO: Make a full url out of the path
		FileName:         path.Base(sqlFile.Path),
		AudioLanguage:    Language(sqlFile.AudioLanguageID.String),
		SubtitleLanguage: subLang,
		MimeType:         sqlFile.MimeType,
	}
}

// StreamFromSQL converts Assetfile rows to the GQL equvivalents
func StreamFromSQL(ctx context.Context, vod2domain string, sqlStream *sqlc.GetStreamsForEpisodesRow) *Stream {

	url := url.URL{
		Path:   sqlStream.Path,
		Host:   vod2domain,
		Scheme: "https",
	}

	return &Stream{
		ID:                strconv.Itoa(int(sqlStream.ID)),
		URL:               url.String(),
		AudioLanguages:    lo.Map(sqlStream.AudioLanguages, func(s string, _ int) Language { return Language(s) }),
		SubtitleLanguages: lo.Map(sqlStream.SubtitleLanguages, func(s string, _ int) Language { return Language(s) }),
		Type:              StreamType(sqlStream.Type),
	}
}
