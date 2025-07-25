package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.74

import (
	"context"
	"encoding/json"
	"strconv"
	"strings"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/generated"
	"github.com/bcc-code/bcc-media-platform/backend/graph/admin/model"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
	null_v4 "gopkg.in/guregu/null.v4"
)

// ImportTimedMetadata is the resolver for the importTimedMetadata field.
func (r *episodesResolver) ImportTimedMetadata(ctx context.Context, obj *model.Episodes, episodeID string) (bool, error) {
	intID, err := strconv.ParseInt(episodeID, 10, 64)
	if err != nil {
		return false, err
	}
	episode, err := r.Loaders.EpisodeLoader.Get(ctx, int(intID))
	if err != nil {
		return false, err
	}
	if !episode.AssetID.Valid {
		return false, nil
	}
	metadata, err := r.Queries.GetAssetTimedMetadata(ctx, episode.AssetID)
	if err != nil {
		return false, err
	}
	err = r.Queries.ClearEpisodeTimedMetadata(ctx, null_v4.IntFrom(intID))
	if err != nil {
		return false, err
	}
	for _, m := range metadata {
		m.EpisodeID = null_v4.IntFrom(intID)

		_, err = r.Queries.InsertTimedMetadata(ctx, sqlc.InsertTimedMetadataParams{
			EpisodeID:   m.EpisodeID,
			Title:       m.Title.String,
			Description: m.Description.String,
			Seconds:     m.Seconds,
			Type:        m.Type,
			ContentType: m.ContentType,
			Label:       m.Label,
			Status:      m.Status,
			Highlight:   m.Highlight,
			SongID:      m.SongID,
		})
		if err != nil {
			return false, err
		}
	}
	return true, nil
}

// ImportTimedMetadata is the resolver for the importTimedMetadata field.
func (r *mediaItemsResolver) ImportTimedMetadata(ctx context.Context, obj *model.MediaItems, mediaItemID string) (bool, error) {
	uid, err := uuid.Parse(mediaItemID)
	if err != nil {
		return false, err
	}
	mediaItem, err := r.Queries.GetMediaItemByID(ctx, uid)
	if err != nil {
		return false, err
	}
	if !mediaItem.AssetID.Valid {
		return false, nil
	}
	metadata, err := r.Queries.GetAssetTimedMetadata(ctx, mediaItem.AssetID)
	if err != nil {
		return false, err
	}
	err = r.Queries.ClearMediaItemTimedMetadata(ctx, mediaItem.ID)
	if err != nil {
		return false, err
	}
	for _, m := range metadata {
		m.MediaitemID = uuid.NullUUID{UUID: mediaItem.ID, Valid: true}

		_, err = r.Queries.InsertTimedMetadata(ctx, sqlc.InsertTimedMetadataParams{
			MediaitemID: m.MediaitemID,
			Title:       m.Title.String,
			Description: m.Description.String,
			Seconds:     m.Seconds,
			Type:        m.Type,
			ContentType: m.ContentType,
			Label:       m.Label,
			Status:      m.Status,
			Highlight:   m.Highlight,
			SongID:      m.SongID,
		})
		if err != nil {
			return false, err
		}
	}
	return true, nil
}

// Collection is the resolver for the collection field.
func (r *previewResolver) Collection(ctx context.Context, obj *model.Preview, filter string) (*model.PreviewCollection, error) {
	ctx = context.WithValue(ctx, "preview", true)

	var f common.Filter

	_ = json.Unmarshal([]byte(filter), &f)

	items, err := r.getItemsForFilter(ctx, f)
	if err != nil {
		return nil, err
	}

	return &model.PreviewCollection{
		Items: items,
	}, nil
}

// Asset is the resolver for the asset field.
func (r *previewResolver) Asset(ctx context.Context, obj *model.Preview, id string) (*model.PreviewAsset, error) {
	ctx = context.WithValue(ctx, "preview", true)

	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return nil, err
	}

	streams, err := r.Queries.GetStreamsForAssets(ctx, []int{int(intID)})
	if err != nil || len(streams) == 0 {
		return nil, err
	}

	streams = lo.Filter(streams, func(s common.Stream, _ int) bool {
		for _, ignore := range common.IgnoreEpisodeAssetEndpoints {
			if strings.Contains(s.Url, ignore) {
				return false
			}
		}
		return true
	})

	stream, found := lo.Find(streams, func(s common.Stream) bool {
		return s.Type == "hls_cmaf"
	})
	if !found {
		stream = streams[0]
	}
	return &model.PreviewAsset{
		URL:  stream.Url,
		Type: stream.Type,
	}, nil
}

// Preview is the resolver for the preview field.
func (r *queryRootResolver) Preview(ctx context.Context) (*model.Preview, error) {
	return &model.Preview{}, nil
}

// Statistics is the resolver for the statistics field.
func (r *queryRootResolver) Statistics(ctx context.Context) (*model.Statistics, error) {
	return &model.Statistics{}, nil
}

// Episodes is the resolver for the episodes field.
func (r *queryRootResolver) Episodes(ctx context.Context) (*model.Episodes, error) {
	return &model.Episodes{}, nil
}

// MediaItems is the resolver for the mediaItems field.
func (r *queryRootResolver) MediaItems(ctx context.Context) (*model.MediaItems, error) {
	return &model.MediaItems{}, nil
}

// LessonProgressGroupedByOrg is the resolver for the lessonProgressGroupedByOrg field.
func (r *statisticsResolver) LessonProgressGroupedByOrg(ctx context.Context, obj *model.Statistics, lessonID string, ageGroups []string, orgMaxSize *int, orgMinSize *int) ([]*model.ProgressByOrg, error) {
	minSize := 0
	maxSize := 9999999
	if orgMinSize != nil {
		minSize = *orgMinSize
	}

	if orgMaxSize != nil {
		maxSize = *orgMaxSize
	}

	stats, err := r.Queries.GetLessonProgressGroupedByOrg(ctx, sqlc.GetLessonProgressGroupedByOrgParams{
		AgeGroups: ageGroups,
		LessonID:  utils.AsUuid(lessonID),
		MinSize:   int32(minSize),
		MaxSize:   int32(maxSize),
	})
	if err != nil {
		return nil, err
	}

	out := []*model.ProgressByOrg{}
	for _, s := range stats {
		out = append(out, &model.ProgressByOrg{
			Name:     s.Name.String,
			Progress: s.Perc,
		})
	}

	return out, err
}

// Episodes returns generated.EpisodesResolver implementation.
func (r *Resolver) Episodes() generated.EpisodesResolver { return &episodesResolver{r} }

// MediaItems returns generated.MediaItemsResolver implementation.
func (r *Resolver) MediaItems() generated.MediaItemsResolver { return &mediaItemsResolver{r} }

// Preview returns generated.PreviewResolver implementation.
func (r *Resolver) Preview() generated.PreviewResolver { return &previewResolver{r} }

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

// Statistics returns generated.StatisticsResolver implementation.
func (r *Resolver) Statistics() generated.StatisticsResolver { return &statisticsResolver{r} }

type episodesResolver struct{ *Resolver }
type mediaItemsResolver struct{ *Resolver }
type previewResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
type statisticsResolver struct{ *Resolver }
