package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
)

func (r *queryRootResolver) Page(ctx context.Context, id string) (gqlmodel.Page, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryRootResolver) Program(ctx context.Context, id string) (gqlmodel.Program, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryRootResolver) Section(ctx context.Context, id string) (gqlmodel.Section, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryRootResolver) Calendar(ctx context.Context) (*gqlmodel.Calendar, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryRootResolver) Event(ctx context.Context, id string) (*gqlmodel.Event, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryRootResolver) AllFAQs(ctx context.Context) ([]*gqlmodel.FAQCategory, error) {
	panic(fmt.Errorf("not implemented"))
}

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

type queryRootResolver struct{ *Resolver }
