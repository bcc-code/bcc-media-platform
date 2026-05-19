package model

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

func SongFrom(ctx context.Context, s *common.Song) *Song {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	urls := s.URLs
	if urls == nil {
		urls = []string{}
	}

	return &Song{
		ID:    s.ID.String(),
		Key:   s.Key,
		Title: s.Title.Get(languages),
		Urls:  urls,
	}
}

func SongCollectionFrom(c *common.SongCollection) *SongCollection {
	return &SongCollection{
		ID:    c.ID.String(),
		Code:  c.Code,
		Title: c.Title,
	}
}
