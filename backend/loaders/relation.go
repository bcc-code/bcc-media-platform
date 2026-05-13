package loaders

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
)

// NewRelationLoader returns a configured batch loader for Lists
func NewRelationLoader[K comparable, R comparable](
	ctx context.Context,
	factory func(ctx context.Context, ids []R) ([]common.Relation[K, R], error),
	opts ...Option,
) *Loader[R, []*K] {
	return NewListMapped(ctx, factory,
		func(r common.Relation[K, R]) R { return r.GetRelationID() },
		func(r common.Relation[K, R]) K { return r.GetKey() },
		opts...)
}
