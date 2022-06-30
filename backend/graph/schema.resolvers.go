package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/user"
)

func (r *queryRootResolver) Page(ctx context.Context, id string) (gqlmodel.Page, error) {
	panic(fmt.Errorf("not implemented"))
}

func (r *queryRootResolver) Program(ctx context.Context, id string) (gqlmodel.Program, error) {
	return gqlmodel.Standalone{
		Assets:        []*gqlmodel.Asset{},
		Chapters:      []*gqlmodel.Chapter{},
		Description:   "Dummy",
		ID:            id,
		Localizations: &gqlmodel.LocalizedProgram{},
		Title:         "Dummy Title",
	}, nil
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

func (r *queryRootResolver) Me(ctx context.Context) (*gqlmodel.User, error) {
	gc, err := GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	usr := user.GetFromCtx(gc)

	u := &gqlmodel.User{
		Anonymous: usr.IsAnonymous(),
		BccMember: usr.IsActiveBCC(),
		Roles:     usr.Roles,
	}

	if pid := gc.GetString(auth0.CtxPersonID); pid != "" {
		u.ID = &pid
	}

	if aud := gc.GetString(auth0.CtxJWTAudience); aud != "" {
		u.Audience = &aud
	}

	if usr.Email != "" {
		u.Email = &usr.Email
	}

	return u, nil
}

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

type queryRootResolver struct{ *Resolver }
