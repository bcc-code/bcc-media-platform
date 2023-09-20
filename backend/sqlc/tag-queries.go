package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/samber/lo"
)

func mapToTags(items []getTagsRow) []common.Tag {
	return lo.Map(items, func(i getTagsRow, _ int) common.Tag {
		var name common.LocaleString
		_ = json.Unmarshal(i.Name.RawMessage, &name)

		return common.Tag{
			ID:   int(i.ID),
			Code: i.Code,
			Name: name,
		}
	})
}

// GetTags returns a list of tags retrieved by ids
func (q *Queries) GetTags(ctx context.Context, ids []int) ([]common.Tag, error) {
	items, err := q.getTags(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToTags(items), nil
}

// ListTags returns a list of tags
func (q *Queries) ListTags(ctx context.Context) ([]common.Tag, error) {
	items, err := q.listTags(ctx)
	if err != nil {
		return nil, err
	}
	return mapToTags(lo.Map(items, func(s listTagsRow, _ int) getTagsRow {
		return getTagsRow(s)
	})), nil
}
