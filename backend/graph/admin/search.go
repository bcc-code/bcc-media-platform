package graph

import (
	"context"
	"strconv"
	"strings"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	apimodel "github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
)

const (
	defaultSearchLimit = 20
	maxSearchLimit     = 100
	// Elasticsearch's default index.max_result_window.
	maxSearchWindow = 10000
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
		f.Types = lo.Map(filter.Types, func(t model.SearchType, _ int) string { return string(t) })
	}
	if !applyForcedSearchFilter(&f, principalFromCtx(ctx).forcedFilter(model.AdminResourceSearch)) {
		return &model.SearchResult{Group: f.Group, Hits: []*model.SearchHit{}}, nil
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
	if off+limit > maxSearchWindow {
		return nil, merry.Errorf("offset + first must not exceed %d", maxSearchWindow)
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

// searchHitURL links to the web app; seasons have no page there, so they link to their show.
func (r *Resolver) searchHitURL(ctx context.Context, hit *model.SearchHit) (*string, error) {
	id, err := strconv.Atoi(hit.ID)
	if err != nil {
		return nil, err
	}
	var path string
	switch hit.Type {
	case model.SearchTypeEpisode:
		e, err := r.Loaders.EpisodeLoader.Get(ctx, id)
		if err != nil || e == nil {
			return nil, err
		}
		path = "/episode/" + e.UUID.String()
	case model.SearchTypeSeason:
		s, err := r.Loaders.SeasonLoader.Get(ctx, id)
		if err != nil || s == nil {
			return nil, err
		}
		path = "/show/" + strconv.Itoa(s.ShowID)
	case model.SearchTypeShow:
		path = "/show/" + hit.ID
	default:
		return nil, merry.Errorf("unsupported search type: %s", hit.Type)
	}
	return lo.ToPtr(webAppURL(r.WebAppURL, path)), nil
}

func webAppURL(base, path string) string {
	return strings.TrimSuffix(base, "/") + path
}

// applyForcedSearchFilter pins the group and narrows the types; it returns false if no requested type is allowed.
func applyForcedSearchFilter(f *search.AdminFilter, forced *model.ForcedFilterInput) bool {
	if forced == nil || forced.Search == nil {
		return true
	}
	if forced.Search.Group != nil {
		f.Group = forced.Search.Group
	}
	if len(forced.Search.Types) > 0 {
		allowed := lo.Map(forced.Search.Types, func(t model.SearchType, _ int) string { return string(t) })
		if len(f.Types) > 0 {
			allowed = lo.Intersect(allowed, f.Types)
		}
		if len(allowed) == 0 {
			return false
		}
		f.Types = allowed
	}
	return true
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

// itemStatus reads the source status; the main API's converters collapse it to published/unlisted.
func itemStatus[T interface {
	comparable
	GetStatus() common.Status
}](ctx context.Context, loader *loaders.Loader[int, T], id string) (apimodel.Status, error) {
	intID, err := strconv.Atoi(id)
	if err != nil {
		return "", err
	}
	item, err := loader.Get(ctx, intID)
	if err != nil {
		return "", err
	}
	var zero T
	if item == zero {
		return "", merry.Errorf("item %s not found", id)
	}
	return statusFrom(item.GetStatus()), nil
}

func statusFrom(s common.Status) apimodel.Status {
	return apimodel.Status(common.StatusFrom(string(s)))
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
