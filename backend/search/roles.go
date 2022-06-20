package search

import (
	"context"
	null_v4 "gopkg.in/guregu/null.v4"
)

var episodeRoles = map[int32][]string{}

func (service *Service) getRolesForEpisode(id int32) (roles []string) {
	if val, ok := episodeRoles[id]; ok {
		return val
	}
	ctx := context.Background()
	result, _ := service.queries.GetRolesForEpisode(ctx, id)
	roles = []string{}
	if result != nil {
		roles = result
	}
	episodeRoles[id] = roles
	return
}

var seasonRoles = map[int32][]string{}

func (service *Service) getRolesForSeason(id int32) (roles []string) {
	if val, ok := seasonRoles[id]; ok {
		return val
	}
	ctx := context.Background()
	result, _ := service.queries.GetRolesForSeason(ctx, null_v4.IntFrom(int64(id)))
	roles = []string{}
	if result != nil {
		roles = result
	}
	episodeRoles[id] = roles
	return
}

var showRoles = map[int32][]string{}

func (service *Service) getRolesForShow(id int32) (roles []string) {
	if val, ok := showRoles[id]; ok {
		return val
	}
	ctx := context.Background()
	result, _ := service.queries.GetRolesForShow(ctx, id)
	roles = []string{}
	if result != nil {
		roles = result
	}
	episodeRoles[id] = roles
	return
}
