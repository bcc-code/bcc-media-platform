package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"time"

	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
)

// Global is the resolver for the global field.
func (r *configResolver) Global(ctx context.Context, obj *gqlmodel.Config, timestamp *string) (*gqlmodel.GlobalConfig, error) {
	conf, err := withCacheAndTimestamp(ctx, "global_config", r.Queries.GetGlobalConfig, time.Second*30, timestamp)
	if err != nil {
		return nil, err
	}
	return &gqlmodel.GlobalConfig{
		LiveOnline:  conf.LiveOnline,
		NpawEnabled: conf.NPAWEnabled,
	}, nil
}

// Config returns generated.ConfigResolver implementation.
func (r *Resolver) Config() generated.ConfigResolver { return &configResolver{r} }

type configResolver struct{ *Resolver }
