package graphpub

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"strconv"

	gqlpublicgenerated "github.com/bcc-code/brunstadtv/backend/graph/public/generated"
	publicmodel "github.com/bcc-code/brunstadtv/backend/graph/public/model"
)

// Episode is the resolver for the episode field.
func (r *queryRootResolver) Episode(ctx context.Context, id string) (*publicmodel.Episode, error) {
	intID, _ := strconv.ParseInt(id, 10, 64)
	episode, err := common.GetFromLoaderByID(ctx, r.Loaders.EpisodeLoader, int(intID))
	if err != nil {
		return nil, err
	}

	languages := []string{"en"}
	var season *publicmodel.Season
	if episode.SeasonID.Valid {
		season = &publicmodel.Season{
			ID: strconv.Itoa(int(episode.SeasonID.Int64)),
		}
	}

	var num *int
	if episode.Number.Valid {
		n := int(episode.Number.Int64)
		num = &n
	}

	return &publicmodel.Episode{
		ID:          strconv.Itoa(episode.ID),
		Title:       episode.Title.Get(languages),
		Description: episode.Description.Get(languages),
		Number:      num,
		Season:      season,
	}, nil
}

// Season is the resolver for the season field.
func (r *queryRootResolver) Season(ctx context.Context, id string) (*publicmodel.Season, error) {
	panic(fmt.Errorf("not implemented"))
}

// Show is the resolver for the show field.
func (r *queryRootResolver) Show(ctx context.Context, id string) (*publicmodel.Show, error) {
	panic(fmt.Errorf("not implemented"))
}

// QueryRoot returns gqlpublicgenerated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() gqlpublicgenerated.QueryRootResolver { return &queryRootResolver{r} }

type queryRootResolver struct{ *Resolver }
