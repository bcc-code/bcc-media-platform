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
	// scope is nil when the grant has none.
	scope *model.PermissionScopeInput
}

// Principal is who an admin request acts as, and what it may do.
type Principal struct {
	superuser bool
	grants    map[model.AdminResource]grant
	// userID is the Directus user behind the request, if any.
	userID uuid.NullUUID
}

type permissionRow struct {
	resource string
	access   string
	scope    json.RawMessage
}

func newPrincipal(rows []permissionRow) *Principal {
	p := &Principal{grants: map[model.AdminResource]grant{}}
	for _, r := range rows {
		res, level := model.AdminResource(r.resource), model.AccessLevel(r.access)
		if !res.IsValid() || !level.IsValid() {
			log.L.Warn().Str("resource", r.resource).Str("access", r.access).Msg("Ignoring unknown admin permission")
			continue
		}
		g := grant{level: level}
		if !isEmptyScope(r.scope) {
			g.scope = &model.PermissionScopeInput{}
			// Drop rather than widen a grant whose restriction can't be read.
			if err := json.Unmarshal(r.scope, g.scope); err != nil {
				log.L.Warn().Err(err).Str("resource", r.resource).Msg("Ignoring admin permission with invalid scope")
				continue
			}
		}
		p.grants[res] = g
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

// scope returns the limits this principal has on resource, or nil.
func (p *Principal) scope(resource model.AdminResource) *model.PermissionScopeInput {
	if p == nil || p.superuser {
		return nil
	}
	return p.grants[resource].scope
}

// allowedGroups returns the group codes the principal may grant or revoke; all is true when it is unrestricted.
func (p *Principal) allowedGroups() (codes []string, all bool) {
	s := p.scope(model.AdminResourceEpisodeAccess)
	if s == nil || s.EpisodeAccess == nil || s.EpisodeAccess.Groups == nil {
		return nil, true
	}
	return s.EpisodeAccess.Groups, false
}

func isEmptyScope(raw json.RawMessage) bool {
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

// SuperuserDirective implements @superuser.
func SuperuserDirective(ctx context.Context, _ any, next graphql.Resolver) (any, error) {
	if p := principalFromCtx(ctx); p == nil || !p.superuser {
		return nil, errForbidden(ctx)
	}
	return next(ctx)
}

func permissionRowsFromInput(inputs []*model.PermissionInput) ([]permissionRow, error) {
	var rows []permissionRow
	seen := map[model.AdminResource]bool{}
	for _, in := range inputs {
		if seen[in.Resource] {
			return nil, fmt.Errorf("duplicate permission for %s", in.Resource)
		}
		seen[in.Resource] = true

		scope := json.RawMessage("{}")
		if in.Scope != nil {
			if in.Scope.Search != nil && in.Resource != model.AdminResourceSearch {
				return nil, fmt.Errorf("a search scope can only be set on the search resource")
			}
			if in.Scope.EpisodeAccess != nil && in.Resource != model.AdminResourceEpisodeAccess {
				return nil, fmt.Errorf("an episodeAccess scope can only be set on the episodeAccess resource")
			}
			raw, err := json.Marshal(in.Scope)
			if err != nil {
				return nil, err
			}
			scope = raw
		}

		rows = append(rows, permissionRow{resource: string(in.Resource), access: string(in.Level), scope: scope})
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
		if !isEmptyScope(r.scope) {
			s := &model.PermissionScope{}
			if err := json.Unmarshal(r.scope, s); err != nil {
				log.L.Warn().Err(err).Str("resource", r.resource).Msg("Invalid permission scope")
			} else {
				p.Scope = s
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
