package gqlmodel

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"net/url"
	"path"
	"strconv"

	"github.com/samber/lo"
)

// FileFrom converts AssetFile rows to the GQL equivalents
func FileFrom(ctx context.Context, file *common.File) *File {
	var subLang *Language
	if file.SubtitleLanguage.Valid {
		l := Language(file.SubtitleLanguage.String)
		subLang = &l
	}

	return &File{
		ID:               strconv.Itoa(file.ID),
		URL:              file.Path, // TODO: Make a full url out of the path
		FileName:         path.Base(file.Path),
		AudioLanguage:    Language(file.AudioLanguage.String),
		SubtitleLanguage: subLang,
		MimeType:         file.MimeType,
	}
}

// StreamFrom converts AssetFile rows to the GQL equivalents
func StreamFrom(ctx context.Context, vod2domain string, stream *common.Stream) *Stream {
	url := url.URL{
		Path:   stream.Path,
		Host:   vod2domain,
		Scheme: "https",
	}

	return &Stream{
		ID:                strconv.Itoa(stream.ID),
		URL:               url.String(),
		AudioLanguages:    lo.Map(stream.AudioLanguages, func(s string, _ int) Language { return Language(s) }),
		SubtitleLanguages: lo.Map(stream.SubtitleLanguages, func(s string, _ int) Language { return Language(s) }),
		Type:              StreamType(stream.Type),
	}
}
