package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.39

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/graph/api/generated"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// Image is the resolver for the image field.
func (r *shortResolver) Image(ctx context.Context, obj *model.Short, style *model.ImageStyle) (*string, error) {
	e, err := r.GetLoaders().ShortLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	return imageOrFallback(ctx, e.Images, style), nil
}

// Streams is the resolver for the streams field.
func (r *shortResolver) Streams(ctx context.Context, obj *model.Short) ([]*model.Stream, error) {
	short, err := r.Loaders.ShortLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	if !short.AssetID.Valid {
		return nil, nil
	}
	streams, err := r.Resolver.Loaders.AssetStreamsLoader.Get(ctx, int(short.AssetID.Int64))
	if err != nil {
		return nil, err
	}

	var out []*model.Stream
	for _, s := range streams {
		stream, err := model.StreamFrom(ctx, r.URLSigner, r.Resolver.APIConfig, s)
		if err != nil {
			return nil, err
		}

		out = append(out, stream)
	}

	return out, nil
}

// Files is the resolver for the files field.
func (r *shortResolver) Files(ctx context.Context, obj *model.Short) ([]*model.File, error) {
	short, err := r.Loaders.ShortLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	if !short.AssetID.Valid {
		return nil, nil
	}

	files, err := r.Resolver.Loaders.AssetFilesLoader.Get(ctx, int(short.AssetID.Int64))
	if err != nil {
		return nil, err
	}

	var out []*model.File
	for _, f := range files {
		out = append(out, model.FileFrom(ctx, r.URLSigner, r.Resolver.APIConfig.GetFilesCDNDomain(), f))
	}
	return out, nil
}

// Short returns generated.ShortResolver implementation.
func (r *Resolver) Short() generated.ShortResolver { return &shortResolver{r} }

type shortResolver struct{ *Resolver }