package graphpub

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"strconv"

	merry "github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	gqlpublicgenerated "github.com/bcc-code/brunstadtv/backend/graph/public/generated"
	publicmodel "github.com/bcc-code/brunstadtv/backend/graph/public/model"
)

// Episode is the resolver for the episode field.
func (r *queryRootResolver) Episode(ctx context.Context, id string) (*publicmodel.Episode, error) {
	intID, _ := strconv.ParseInt(id, 10, 64)
	item, err := common.GetFromLoaderByID(ctx, r.Loaders.EpisodeLoader, int(intID))
	if err != nil {
		return nil, err
	}
	if item == nil {
		return nil, merry.New("item not found", merry.WithUserMessage("item not found"))
	}

	languages := []string{"en"}
	var season *publicmodel.Season
	if item.SeasonID.Valid {
		season = &publicmodel.Season{
			ID: strconv.Itoa(int(item.SeasonID.Int64)),
		}
	}

	var num *int
	if item.Number.Valid {
		n := int(item.Number.Int64)
		num = &n
	}

	var image *string
	if item.Image.Valid {
		image = &item.Image.String
	}

	return &publicmodel.Episode{
		ID:          strconv.Itoa(item.ID),
		Title:       item.Title.Get(languages),
		Description: item.Description.Get(languages),
		Number:      num,
		Season:      season,
		Image:       image,
	}, nil
}

// Season is the resolver for the season field.
func (r *queryRootResolver) Season(ctx context.Context, id string) (*publicmodel.Season, error) {
	intID, _ := strconv.ParseInt(id, 10, 64)
	item, err := common.GetFromLoaderByID(ctx, r.Loaders.SeasonLoader, int(intID))
	if err != nil {
		return nil, err
	}
	if item == nil {
		return nil, merry.New("item not found", merry.WithUserMessage("item not found"))
	}

	languages := []string{"en"}

	var image *string
	if item.Image.Valid {
		image = &item.Image.String
	}

	return &publicmodel.Season{
		ID:          strconv.Itoa(item.ID),
		Title:       item.Title.Get(languages),
		Description: item.Description.Get(languages),
		Number:      item.Number,
		Image:       image,
		Show: &publicmodel.Show{
			ID: strconv.Itoa(item.ShowID),
		},
	}, nil
}

// Show is the resolver for the show field.
func (r *queryRootResolver) Show(ctx context.Context, id string) (*publicmodel.Show, error) {
	intID, _ := strconv.ParseInt(id, 10, 64)
	item, err := common.GetFromLoaderByID(ctx, r.Loaders.ShowLoader, int(intID))
	if err != nil {
		return nil, err
	}
	if item == nil {
		return nil, merry.New("item not found", merry.WithUserMessage("item not found"))
	}

	languages := []string{"en"}

	var image *string
	if item.Image.Valid {
		image = &item.Image.String
	}

	return &publicmodel.Show{
		ID:          strconv.Itoa(item.ID),
		Title:       item.Title.Get(languages),
		Description: item.Description.Get(languages),
		Image:       image,
	}, nil
}

// QueryRoot returns gqlpublicgenerated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() gqlpublicgenerated.QueryRootResolver { return &queryRootResolver{r} }

type queryRootResolver struct{ *Resolver }
