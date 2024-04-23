package graph

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// FilteredContributions takes a list of contributions and filters out items based on roles etc
func FilteredContributions(ctx context.Context, types []string, items []*common.Contribution, fl *common.FilteredLoaders) ([]*common.Contribution, error) {
	if items == nil {
		return nil, nil
	}

	var result []*common.Contribution
	var episodeIDs []int
	var tmIDs []uuid.UUID

	for _, i := range items {
		switch i.ItemType {
		case "episode":
			episodeIDs = append(episodeIDs, utils.AsInt(i.ItemID))
		case "chapter":
			tmIDs = append(tmIDs, utils.AsUuid(i.ItemID))
		}
	}

	allowedEpisodeIds, err := fl.EpisodeFilterLoader.GetMany(ctx, episodeIDs)
	if err != nil {
		return nil, err
	}
	allowedTMIds, err := fl.TimedMetadataFilterLoader.GetMany(ctx, tmIDs)
	if err != nil {
		return nil, err
	}

	for _, i := range items {
		if len(types) > 0 && !lo.Contains(types, i.Type) {
			continue
		}
		switch i.ItemType {
		case "episode":
			for _, id := range allowedEpisodeIds {
				if id != nil && utils.AsInt(i.ItemID) == *id {
					result = append(result, i)
					break
				}
			}
		case "chapter":
			for _, id := range allowedTMIds {
				if id != nil && utils.AsUuid(i.ItemID) == *id {
					result = append(result, i)
					break
				}
			}
		}
	}

	return result, nil
}
