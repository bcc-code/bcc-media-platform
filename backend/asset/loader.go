package asset

import (
	"context"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewBatchFileLoader returns a configured batch loader for GQL File
func NewBatchFileLoader(queries sqlc.Queries) *dataloader.Loader[int, []*sqlc.GetFilesForEpisodesRow] {
	batchLoadFiles := func(ctx context.Context, keys []int) []*dataloader.Result[[]*sqlc.GetFilesForEpisodesRow] {
		results := []*dataloader.Result[[]*sqlc.GetFilesForEpisodesRow]{}

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := queries.GetFilesForEpisodes(ctx, ids)

		resMap := map[int][]*sqlc.GetFilesForEpisodesRow{}

		if err == nil {
			for _, r := range res {
				key := int(r.EpisodesID)

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*sqlc.GetFilesForEpisodesRow{}
				}

				resMap[key] = append(resMap[key], &r)
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[[]*sqlc.GetFilesForEpisodesRow]{
				Error: err,
			}

			if val, ok := resMap[k]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	return dataloader.NewBatchedLoader(batchLoadFiles)
}

// GetFilesForEpisode retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as avalilable)
func GetFilesForEpisode(ctx context.Context, loader *dataloader.Loader[int, []*sqlc.GetFilesForEpisodesRow], id string) ([]*sqlc.GetFilesForEpisodesRow, error) {
	intID, _ := strconv.ParseInt(id, 10, 32)
	thunk := loader.Load(ctx, int(intID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}

// NewBatchStreamLoader returns a configured batch loader for GQL Stream
func NewBatchStreamLoader(queries sqlc.Queries) *dataloader.Loader[int, []*sqlc.GetStreamsForEpisodesRow] {
	batchLoadStreams := func(ctx context.Context, keys []int) []*dataloader.Result[[]*sqlc.GetStreamsForEpisodesRow] {
		results := []*dataloader.Result[[]*sqlc.GetStreamsForEpisodesRow]{}

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := queries.GetStreamsForEpisodes(ctx, ids)
		resMap := map[int][]*sqlc.GetStreamsForEpisodesRow{}

		if err == nil {
			for _, r := range res {
				key := int(r.EpisodesID)

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*sqlc.GetStreamsForEpisodesRow{}
				}

				resMap[key] = append(resMap[key], &r)
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[[]*sqlc.GetStreamsForEpisodesRow]{
				Error: err,
			}

			if val, ok := resMap[k]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	return dataloader.NewBatchedLoader(batchLoadStreams)
}

// GetStreamsForEpisode retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as avalilable)
func GetStreamsForEpisode(ctx context.Context, loader *dataloader.Loader[int, []*sqlc.GetStreamsForEpisodesRow], id string) ([]*sqlc.GetStreamsForEpisodesRow, error) {
	intID, _ := strconv.ParseInt(id, 10, 32)
	thunk := loader.Load(ctx, int(intID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
