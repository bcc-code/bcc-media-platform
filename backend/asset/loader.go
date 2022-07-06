package asset

import (
	"context"
	"strconv"

	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/davecgh/go-spew/spew"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// NewBatchFileLoader returns a configured batch loader for GQL File
func NewBatchFileLoader(queries sqlc.Queries) *dataloader.Loader[int, []*gqlmodel.File] {
	batchLoadFiles := func(ctx context.Context, keys []int) []*dataloader.Result[[]*gqlmodel.File] {
		results := []*dataloader.Result[[]*gqlmodel.File]{}

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := queries.GetFilesForEpisodes(ctx, ids)

		resMap := map[int][]*gqlmodel.File{}

		if err == nil {
			for _, r := range res {
				key := int(r.EpisodesID)

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*gqlmodel.File{}
				}

				gql := gqlmodel.FileFromSQL(ctx, r)
				resMap[key] = append(resMap[key], gql)
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[[]*gqlmodel.File]{
				Error: err,
			}

			if val, ok := resMap[k]; ok {
				r.Data = val
			}

			results = append(results, r)
		}

		return results
	}

	// Currently we do not want to cache at the GQL level
	cache := &dataloader.NoCache[int, []*gqlmodel.File]{}
	return dataloader.NewBatchedLoader(batchLoadFiles, dataloader.WithCache[int, []*gqlmodel.File](cache))
}

// GetFilesForEpisode retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as avalilable)
func GetFilesForEpisode(ctx context.Context, loader *dataloader.Loader[int, []*gqlmodel.File], id string) ([]*gqlmodel.File, error) {
	intID, _ := strconv.ParseInt(id, 10, 32)
	thunk := loader.Load(ctx, int(intID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}

// NewBatchStreamLoader returns a configured batch loader for GQL Stream
func NewBatchStreamLoader(queries sqlc.Queries) *dataloader.Loader[int, []*gqlmodel.Stream] {
	batchLoadStreams := func(ctx context.Context, keys []int) []*dataloader.Result[[]*gqlmodel.Stream] {
		results := []*dataloader.Result[[]*gqlmodel.Stream]{}

		ids := lo.Map(keys, func(key int, _ int) int32 {
			return int32(key)
		})

		res, err := queries.GetStreamsForEpisodes(ctx, ids)
		resMap := map[int][]*gqlmodel.Stream{}

		if err == nil {
			for _, r := range res {
				key := int(r.EpisodesID)

				if _, ok := resMap[key]; !ok {
					resMap[key] = []*gqlmodel.Stream{}
				}

				gql := gqlmodel.StreamFromSQL(ctx, r)
				resMap[key] = append(resMap[key], gql)
			}
		}

		for _, k := range keys {
			r := &dataloader.Result[[]*gqlmodel.Stream]{
				Error: err,
			}

			if val, ok := resMap[k]; ok {
				r.Data = val
			}

			results = append(results, r)
		}
		spew.Dump(results)

		return results
	}

	// Currently we do not want to cache at the GQL level
	cache := &dataloader.NoCache[int, []*gqlmodel.Stream]{}
	return dataloader.NewBatchedLoader(batchLoadStreams, dataloader.WithCache[int, []*gqlmodel.Stream](cache))
}

// GetStreamsForEpisode retrieves file assets currently associated with the specified asset
//
// It uses the dataloader to efficiently load data from DB or cache (as avalilable)
func GetStreamsForEpisode(ctx context.Context, loader *dataloader.Loader[int, []*gqlmodel.Stream], id string) ([]*gqlmodel.Stream, error) {
	intID, _ := strconv.ParseInt(id, 10, 32)
	thunk := loader.Load(ctx, int(intID))
	result, err := thunk()
	if err != nil {
		return nil, err
	}

	return result, nil
}
