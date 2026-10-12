package graph

import (
	"context"
	"strconv"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
)

// ctxForcedSearchGroup is set by AuthExtension for API keys that are pinned to a usergroup.
const ctxForcedSearchGroup = "admin-forced-search-group"

const (
	defaultSearchLimit = 20
	maxSearchLimit     = 100
)

var collectionToSearchType = map[string]model.SearchType{
	"episodes": model.SearchTypeEpisode,
	"seasons":  model.SearchTypeSeason,
	"shows":    model.SearchTypeShow,
}

func (r *Resolver) search(ctx context.Context, query string, filter *model.SearchFilter, first, offset *int) (*model.SearchResult, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	f := search.AdminFilter{}
	if filter != nil {
		f.Group = filter.Group
		f.Types = lo.Map(filter.Types, func(t model.SearchType, _ int) string { return string(t) })
	}
	if forced := ginCtx.GetString(ctxForcedSearchGroup); forced != "" {
		f.Group = &forced
	}

	if f.Group != nil {
		groups, err := r.Queries.GetRolesWithCode(ctx, []string{*f.Group})
		if err != nil {
			return nil, err
		}
		if len(groups) == 0 {
			return nil, merry.Errorf("unknown usergroup: %s", *f.Group)
		}
	}

	limit := defaultSearchLimit
	if first != nil {
		limit = min(max(*first, 1), maxSearchLimit)
	}
	off := 0
	if offset != nil {
		off = max(*offset, 0)
	}

	res, err := r.SearchService.AdminSearch(ctx, query, f, limit, off, user.GetLanguagesFromCtx(ginCtx))
	if err != nil {
		return nil, err
	}

	out := &model.SearchResult{
		Total: res.Total,
		Group: f.Group,
		Hits:  []*model.SearchHit{},
	}
	for _, h := range res.Hits {
		t, ok := collectionToSearchType[h.Collection]
		if !ok {
			continue
		}
		out.Hits = append(out.Hits, &model.SearchHit{
			ID:    strconv.Itoa(h.ID),
			Type:  t,
			Score: h.Score,
		})
	}
	return out, nil
}

func permissions(ctx context.Context, loader *loaders.Loader[int, *common.Permissions[int]], id string) (*common.Permissions[int], error) {
	intID, err := strconv.Atoi(id)
	if err != nil {
		return nil, err
	}
	p, err := loader.Get(ctx, intID)
	if err != nil || p != nil {
		return p, err
	}
	return &common.Permissions[int]{ItemID: intID}, nil
}

func availabilityFrom(a common.Availability) *model.Availability {
	format := func(t time.Time) *string {
		if t.IsZero() {
			return nil
		}
		s := t.Format(time.RFC3339)
		return &s
	}
	return &model.Availability{
		Published:   a.Published,
		Unlisted:    a.Unlisted,
		From:        format(a.From),
		To:          format(a.To),
		PublishedOn: format(a.PublishedOn),
	}
}

func rolesFrom(r common.Roles) *model.Roles {
	return &model.Roles{
		Access:      lo.Ternary(r.Access == nil, []string{}, r.Access),
		Download:    lo.Ternary(r.Download == nil, []string{}, r.Download),
		EarlyAccess: lo.Ternary(r.EarlyAccess == nil, []string{}, r.EarlyAccess),
	}
}
