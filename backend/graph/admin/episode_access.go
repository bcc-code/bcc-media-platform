package graph

import (
	"context"
	"slices"
	"strconv"
	"strings"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	apimodel "github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// baseRoles are the groups whose membership the API computes; apps add prefixed variants (see common.Application.ComputedRoles).
var baseRoles = []string{user.RolePublic, user.RoleRegistered, user.RoleBCCMember, user.RoleNonBCCMember}

func isAutoGroup(code string, apps []common.Application) bool {
	if slices.Contains(baseRoles, code) {
		return true
	}
	for _, app := range apps {
		for _, prefix := range []string{app.Code, app.GroupSlug()} {
			if prefix == "" {
				continue
			}
			if rest, ok := strings.CutPrefix(code, prefix+"-"); ok && slices.Contains(baseRoles, rest) {
				return true
			}
		}
	}
	return false
}

type groupListQueries struct {
	add    func(ctx context.Context, q *sqlc.Queries, id uuid.UUID, codes []string) error
	remove func(ctx context.Context, q *sqlc.Queries, id uuid.UUID, codes []string) error
}

var groupListTables = map[model.GroupList]groupListQueries{
	model.GroupListAccess: {
		add: func(ctx context.Context, q *sqlc.Queries, id uuid.UUID, codes []string) error {
			return q.AddMediaItemUsergroups(ctx, sqlc.AddMediaItemUsergroupsParams{ID: id, Codes: codes})
		},
		remove: func(ctx context.Context, q *sqlc.Queries, id uuid.UUID, codes []string) error {
			return q.RemoveMediaItemUsergroups(ctx, sqlc.RemoveMediaItemUsergroupsParams{ID: id, Codes: codes})
		},
	},
	model.GroupListDownload: {
		add: func(ctx context.Context, q *sqlc.Queries, id uuid.UUID, codes []string) error {
			return q.AddMediaItemDownloadUsergroups(ctx, sqlc.AddMediaItemDownloadUsergroupsParams{ID: id, Codes: codes})
		},
		remove: func(ctx context.Context, q *sqlc.Queries, id uuid.UUID, codes []string) error {
			return q.RemoveMediaItemDownloadUsergroups(ctx, sqlc.RemoveMediaItemDownloadUsergroupsParams{ID: id, Codes: codes})
		},
	},
	model.GroupListEarlyAccess: {
		add: func(ctx context.Context, q *sqlc.Queries, id uuid.UUID, codes []string) error {
			return q.AddMediaItemEarlyAccessUsergroups(ctx, sqlc.AddMediaItemEarlyAccessUsergroupsParams{ID: id, Codes: codes})
		},
		remove: func(ctx context.Context, q *sqlc.Queries, id uuid.UUID, codes []string) error {
			return q.RemoveMediaItemEarlyAccessUsergroups(ctx, sqlc.RemoveMediaItemEarlyAccessUsergroupsParams{ID: id, Codes: codes})
		},
	},
}

// changeEpisodeAccess grants (add) or revokes the groups on the episode's media item; all codes are checked before anything is written.
func (r *Resolver) changeEpisodeAccess(ctx context.Context, input model.EpisodeAccessInput, add bool) (*model.EpisodeAccessResult, error) {
	codes := lo.Uniq(input.Groups)
	lists := lo.Uniq(input.Lists)
	if len(codes) == 0 || len(lists) == 0 {
		return nil, merry.New("groups and lists must not be empty")
	}

	episodeID, err := strconv.Atoi(input.EpisodeID)
	if err != nil {
		return nil, merry.Errorf("invalid episode id: %s", input.EpisodeID)
	}
	episode, err := r.Loaders.EpisodeLoader.Get(ctx, episodeID)
	if err != nil {
		return nil, err
	}
	if episode == nil {
		return nil, merry.Errorf("episode %d not found", episodeID)
	}
	if !episode.MediaItemID.Valid {
		return nil, merry.Errorf("episode %d has no media item", episodeID)
	}
	mediaItemID := episode.MediaItemID.UUID

	if allowed, all := principalFromCtx(ctx).allowedGroups(); !all {
		for _, c := range codes {
			if !slices.Contains(allowed, c) {
				return nil, errForbidden(ctx)
			}
		}
	}

	existing, err := r.Queries.GetRolesWithCode(ctx, codes)
	if err != nil {
		return nil, err
	}
	missing, _ := lo.Difference(codes, lo.Map(existing, func(g sqlc.GetRolesWithCodeRow, _ int) string { return g.Code }))
	if add && len(missing) > 0 {
		apps, err := r.Queries.ListApplications(ctx)
		if err != nil {
			return nil, err
		}
		for _, c := range missing {
			if !isAutoGroup(c, apps) {
				return nil, merry.Errorf("unknown usergroup: %s", c)
			}
		}
	}

	tx, err := r.DB.BeginTx(ctx, nil)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback() //nolint:errcheck
	q := r.Queries.WithTx(tx)
	if add && len(missing) > 0 {
		if err := q.InsertMissingUsergroups(ctx, missing); err != nil {
			return nil, err
		}
	}
	for _, l := range lists {
		t := groupListTables[l]
		if add {
			err = t.add(ctx, q, mediaItemID, codes)
		} else {
			err = t.remove(ctx, q, mediaItemID, codes)
		}
		if err != nil {
			return nil, err
		}
	}
	if err := tx.Commit(); err != nil {
		return nil, err
	}

	return r.afterEpisodeAccessChange(ctx, episodeID, mediaItemID)
}

// afterEpisodeAccessChange refreshes caches, search and filters for every episode on the media item, and builds the result.
func (r *Resolver) afterEpisodeAccessChange(ctx context.Context, episodeID int, mediaItemID uuid.UUID) (*model.EpisodeAccessResult, error) {
	ids, err := r.Queries.GetEpisodeIDsByMediaItemID(ctx, mediaItemID)
	if err != nil {
		return nil, err
	}
	for _, id := range ids {
		r.Loaders.EpisodePermissionLoader.Clear(ctx, id)
		if err := r.SearchService.IndexModel(ctx, "episodes", strconv.Itoa(id)); err != nil {
			log.L.Warn().Err(err).Int("episodeId", id).Msg("Failed to reindex episode after access change")
		}
	}
	go func(ctx context.Context) {
		if err := r.Queries.RefreshView(ctx, "filter_dataset"); err != nil {
			log.L.Warn().Err(err).Msg("Failed to refresh filter_dataset after access change")
		}
	}(context.WithoutCancel(ctx))

	episodes, err := r.Loaders.EpisodeLoader.GetMany(ctx, ids)
	if err != nil {
		return nil, err
	}
	perms, err := r.Queries.GetPermissionsForEpisodes(ctx, []int{episodeID})
	if err != nil {
		return nil, err
	}
	roles := common.Roles{}
	if len(perms) > 0 {
		roles = perms[0].Roles
	}
	return &model.EpisodeAccessResult{
		Episodes: lo.FilterMap(episodes, func(e *common.Episode, _ int) (*apimodel.Episode, bool) {
			if e == nil {
				return nil, false
			}
			return apimodel.EpisodeFrom(ctx, e), true
		}),
		Roles: rolesFrom(roles),
	}, nil
}

// assignableGroups lists the groups the caller may grant or revoke.
func (r *Resolver) assignableGroups(ctx context.Context) ([]*model.Group, error) {
	all, err := r.Queries.ListUsergroups(ctx)
	if err != nil {
		return nil, err
	}
	allowed, unrestricted := principalFromCtx(ctx).allowedGroups()
	if unrestricted {
		return lo.Map(all, func(g sqlc.ListUsergroupsRow, _ int) *model.Group {
			return &model.Group{Code: g.Code, Name: g.Name}
		}), nil
	}
	names := lo.SliceToMap(all, func(g sqlc.ListUsergroupsRow) (string, string) { return g.Code, g.Name })
	return lo.Map(allowed, func(code string, _ int) *model.Group {
		// An auto group without a row yet is named by its code, as grant would create it.
		name, ok := names[code]
		return &model.Group{Code: code, Name: lo.Ternary(ok, name, code)}
	}), nil
}
