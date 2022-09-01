package gqlmodel

import (
	"context"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
)

// CollectionFrom converts common.Collection to Collection
func CollectionFrom(ctx context.Context, s *common.Collection) *Collection {
	return &Collection{
		ID: strconv.Itoa(s.ID),
	}
}
