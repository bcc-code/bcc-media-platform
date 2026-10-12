package graph

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"slices"

	"github.com/99designs/gqlgen/graphql"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/vektah/gqlparser/v2/gqlerror"
)

// ctxPrincipal holds the *Principal that AuthExtension resolved for the request.
const ctxPrincipal = "admin-principal"

// apiKeyPrefix marks admin API keys so they are recognisable in configs and logs.
const apiKeyPrefix = "bccm_"

type grant struct {
	level model.AccessLevel
	// forcedFilter is a JSON-encoded ForcedFilterInput; "{}" when the grant has none.
	forcedFilter json.RawMessage
}

// Principal is who an admin request acts as, and what it may do.
type Principal struct {
	superuser bool
	grants    map[model.AdminResource]grant
	// userID is the Directus user behind the request, if any.
	userID uuid.NullUUID
}

type permissionRow struct {
	resource     string
	access       string
	forcedFilter json.RawMessage
}

func newPrincipal(rows []permissionRow) *Principal {
	p := &Principal{grants: map[model.AdminResource]grant{}}
	for _, r := range rows {
		res, level := model.AdminResource(r.resource), model.AccessLevel(r.access)
		if !res.IsValid() || !level.IsValid() {
			log.L.Warn().Str("resource", r.resource).Str("access", r.access).Msg("Ignoring unknown admin permission")
			continue
		}
		p.grants[res] = grant{level: level, forcedFilter: r.forcedFilter}
	}
	return p
}

func (p *Principal) allows(resource model.AdminResource, level model.AccessLevel) bool {
	if p == nil {
		return false
	}
	if p.superuser {
		return true
	}
	g, ok := p.grants[resource]
	return ok && (level == model.AccessLevelRead || g.level == model.AccessLevelWrite)
}

// forcedFilter returns the filters this principal is pinned to for resource, or nil.
func (p *Principal) forcedFilter(resource model.AdminResource) (*model.ForcedFilterInput, error) {
	if p == nil || p.superuser {
		return nil, nil
	}
	g, ok := p.grants[resource]
	if !ok || isEmptyFilter(g.forcedFilter) {
		return nil, nil
	}
	f := &model.ForcedFilterInput{}
	if err := json.Unmarshal(g.forcedFilter, f); err != nil {
		return nil, fmt.Errorf("invalid forced filter for %s: %w", resource, err)
	}
	return f, nil
}

func isEmptyFilter(raw json.RawMessage) bool {
	trimmed := bytes.TrimSpace(raw)
	return len(trimmed) == 0 || bytes.Equal(trimmed, []byte("{}")) || bytes.Equal(trimmed, []byte("null"))
}

func principalFromCtx(ctx context.Context) *Principal {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil
	}
	v, _ := ginCtx.Get(ctxPrincipal)
	p, _ := v.(*Principal)
	return p
}

func errForbidden(ctx context.Context) *gqlerror.Error {
	return &gqlerror.Error{
		Path:    graphql.GetPath(ctx),
		Message: "forbidden",
		Extensions: map[string]interface{}{
			"code": "FORBIDDEN",
		},
	}
}

// AccessDirective implements @access.
func AccessDirective(ctx context.Context, _ any, next graphql.Resolver, resource model.AdminResource, level model.AccessLevel) (any, error) {
	if !principalFromCtx(ctx).allows(resource, level) {
		return nil, errForbidden(ctx)
	}
	return next(ctx)
}

// permissionRowsFromInput validates grants and checks the caller may hand them out:
// it must hold each level itself, and grants on a resource it is pinned on must carry the same pin.
func permissionRowsFromInput(caller *Principal, inputs []*model.PermissionInput) ([]permissionRow, error) {
	var rows []permissionRow
	seen := map[model.AdminResource]bool{}
	for _, in := range inputs {
		if seen[in.Resource] {
			return nil, fmt.Errorf("duplicate permission for %s", in.Resource)
		}
		seen[in.Resource] = true

		forced := json.RawMessage("{}")
		if in.ForcedFilter != nil {
			if in.ForcedFilter.Search != nil && in.Resource != model.AdminResourceSearch {
				return nil, fmt.Errorf("a search filter can only be forced on the search resource")
			}
			raw, err := json.Marshal(in.ForcedFilter)
			if err != nil {
				return nil, err
			}
			forced = raw
		}

		if !caller.allows(in.Resource, in.Level) {
			return nil, fmt.Errorf("cannot grant %s access to %s without holding it", in.Level, in.Resource)
		}
		callerFilter, err := caller.forcedFilter(in.Resource)
		if err != nil {
			return nil, err
		}
		if callerFilter != nil {
			want, err := json.Marshal(callerFilter)
			if err != nil {
				return nil, err
			}
			if !bytes.Equal(want, forced) {
				return nil, fmt.Errorf("grants on %s must carry your own forced filter", in.Resource)
			}
		}

		rows = append(rows, permissionRow{resource: string(in.Resource), access: string(in.Level), forcedFilter: forced})
	}
	return rows, nil
}

func permissionsToModel(rows []permissionRow) []*model.Permission {
	out := []*model.Permission{}
	for _, r := range rows {
		p := &model.Permission{Resource: model.AdminResource(r.resource), Level: model.AccessLevel(r.access)}
		if !p.Resource.IsValid() || !p.Level.IsValid() {
			continue
		}
		if !isEmptyFilter(r.forcedFilter) {
			f := &model.ForcedFilter{}
			if err := json.Unmarshal(r.forcedFilter, f); err != nil {
				log.L.Warn().Err(err).Str("resource", r.resource).Msg("Invalid forced filter")
			} else {
				p.ForcedFilter = f
			}
		}
		out = append(out, p)
	}
	slices.SortFunc(out, func(a, b *model.Permission) int {
		switch {
		case a.Resource < b.Resource:
			return -1
		case a.Resource > b.Resource:
			return 1
		}
		return 0
	})
	return out
}
