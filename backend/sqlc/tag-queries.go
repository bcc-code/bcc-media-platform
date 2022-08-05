package sqlc

import (
	"context"
	"github.com/samber/lo"
)

// GetTags returns a list of tags retrieved by ids
func (q *Queries) GetTags(ctx context.Context, ids []int32) ([]TagExpanded, error) {
	return q.getTags(ctx, ids)
}

// ListTags returns a list of tags
func (q *Queries) ListTags(ctx context.Context) ([]TagExpanded, error) {
	items, err := q.listTags(ctx)
	if err != nil {
		return nil, err
	}
	return lo.Map(items, func(s listTagsRow, _ int) TagExpanded {
		return TagExpanded(s)
	}), nil
}
