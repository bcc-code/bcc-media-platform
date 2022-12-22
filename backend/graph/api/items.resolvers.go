package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"strconv"
	"time"

	merry "github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/applications"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/items/show"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
	null "gopkg.in/guregu/null.v4"
)

// AvailableFrom is the resolver for the availableFrom field.
func (r *episodeResolver) AvailableFrom(ctx context.Context, obj *model.Episode) (string, error) {
	perms, err := batchloaders.GetByID(ctx, r.Loaders.EpisodePermissionLoader, utils.AsInt(obj.ID))
	if err != nil {
		return "", err
	}
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return "", err
	}
	roles := user.GetRolesFromCtx(ginCtx)
	if len(lo.Intersect(roles, perms.Roles.EarlyAccess)) == 0 {
		return perms.Availability.From.Format(time.RFC3339), nil
	}
	return "1800-01-01T00:00:00Z", nil
}

// Image is the resolver for the image field.
func (r *episodeResolver) Image(ctx context.Context, obj *model.Episode, style *model.ImageStyle) (*string, error) {
	e, err := batchloaders.GetByID(ctx, r.Loaders.EpisodeLoader, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	var fallbacks []common.Images
	if obj.Season != nil {
		s, err := batchloaders.GetByID(ctx, r.Loaders.SeasonLoader, utils.AsInt(obj.Season.ID))
		if err != nil {
			return nil, err
		}
		fallbacks = append(fallbacks, s.Images)
		sh, err := batchloaders.GetByID(ctx, r.Loaders.ShowLoader, s.ShowID)
		if err != nil {
			return nil, err
		}
		fallbacks = append(fallbacks, sh.Images)
	}

	return imageOrFallback(ctx, e.Images, style, fallbacks...), nil
}

// Streams is the resolver for the streams field.
func (r *episodeResolver) Streams(ctx context.Context, obj *model.Episode) ([]*model.Stream, error) {
	err := user.ValidateAccessWithFrom(ctx, r.Loaders.EpisodePermissionLoader, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}

	intID, _ := strconv.ParseInt(obj.ID, 10, 32)
	streams, err := batchloaders.GetForKey(ctx, r.Resolver.Loaders.StreamsLoader, int(intID))
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
func (r *episodeResolver) Files(ctx context.Context, obj *model.Episode) ([]*model.File, error) {
	err := user.ValidateAccessWithFrom(ctx, r.Loaders.EpisodePermissionLoader, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}

	intID, err := strconv.ParseInt(obj.ID, 10, 32)
	if err != nil {
		return nil, err
	}

	files, err := batchloaders.GetForKey(ctx, r.Resolver.Loaders.FilesLoader, int(intID))
	if err != nil {
		return nil, err
	}

	var out []*model.File
	for _, f := range files {
		out = append(out, model.FileFrom(ctx, r.URLSigner, r.Resolver.APIConfig.GetFilesCDNDomain(), f))
	}
	return out, nil
}

// Season is the resolver for the season field.
func (r *episodeResolver) Season(ctx context.Context, obj *model.Episode) (*model.Season, error) {
	if obj.Season != nil {
		return r.QueryRoot().Season(ctx, obj.Season.ID)
	}
	return nil, nil
}

// Progress is the resolver for the progress field.
func (r *episodeResolver) Progress(ctx context.Context, obj *model.Episode) (*int, error) {
	profileLoaders := r.ProfileLoaders(ctx)
	if profileLoaders == nil {
		return nil, nil
	}
	progress, err := profileLoaders.ProgressLoader.Get(ctx, utils.AsInt(obj.ID))
	if err != nil || progress == nil {
		return nil, err
	}
	if progress.Progress <= 10 || (float64(progress.Progress)/float64(progress.Duration)) > 0.8 {
		return nil, nil
	}
	return &progress.Progress, nil
}

// Context is the resolver for the context field.
func (r *episodeResolver) Context(ctx context.Context, obj *model.Episode) (model.EpisodeContextUnion, error) {
	var collectionId *int

	ginCtx, _ := utils.GinCtx(ctx)
	episodeContext, ok := ginCtx.Value(episodeContextKey).(common.EpisodeContext)

	if !ok {
		progress, err := r.ProfileLoaders(ctx).ProgressLoader.Get(ctx, utils.AsInt(obj.ID))
		if err != nil {
			return nil, err
		}
		if progress != nil {
			episodeContext = progress.Context
		}
	}

	if episodeContext.CollectionID.Valid {
		intId := int(episodeContext.CollectionID.Int64)
		collectionId = &intId
	}

	if collectionId != nil {
		col, err := batchloaders.GetByID(ctx, r.Loaders.CollectionLoader, *collectionId)
		if err != nil {
			return nil, err
		}
		languages := user.GetLanguagesFromCtx(ginCtx)

		strID := strconv.Itoa(*collectionId)
		return &model.ContextCollection{
			ID:   strID,
			Slug: col.Slugs.GetValueOrNil(languages),
		}, nil
	}
	if obj.Season != nil {
		return r.QueryRoot().Season(ctx, obj.Season.ID)
	}

	return nil, nil
}

// RelatedItems is the resolver for the relatedItems field.
func (r *episodeResolver) RelatedItems(ctx context.Context, obj *model.Episode, first *int, offset *int) (*model.SectionItemPagination, error) {
	var collectionId *int
	if obj.Type == model.EpisodeTypeStandalone {
		ginCtx, err := utils.GinCtx(ctx)
		if err != nil {
			return nil, err
		}
		app, err := applications.GetFromCtx(ginCtx)
		if err != nil {
			return nil, err
		}
		if app.RelatedCollectionID.Valid {
			intID := int(app.RelatedCollectionID.Int64)
			collectionId = &intID
		}
	}

	if collectionId != nil {
		page, err := sectionCollectionEntryResolver(ctx, r.Loaders, r.FilteredLoaders(ctx), &common.Section{
			CollectionID: null.IntFrom(int64(*collectionId)),
			Style:        "default",
		}, first, offset)
		if err != nil {
			return nil, err
		}
		return &model.SectionItemPagination{
			Total:  page.Total,
			First:  page.First,
			Offset: page.Offset,
			Items:  page.Items,
		}, nil
	}
	return nil, nil
}

// Lessons is the resolver for the lessons field.
func (r *episodeResolver) Lessons(ctx context.Context, obj *model.Episode, first *int, offset *int) (*model.LessonPagination, error) {
	ids, err := r.GetFilteredLoaders(ctx).EpisodeStudyLessonsLoader.Get(ctx, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	page := utils.Paginate(ids, first, offset, nil)

	lessons, err := r.Loaders.StudyLessonLoader.GetMany(ctx, utils.PointerArrayToArray(page.Items))
	if err != nil {
		return nil, err
	}

	return &model.LessonPagination{
		Items:  utils.MapWithCtx(ctx, lessons, model.LessonFrom),
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
	}, nil
}

// ShareRestriction is the resolver for the shareCode field.
func (r *episodeResolver) ShareRestriction(ctx context.Context, obj *model.Episode) (model.ShareRestriction, error) {
	perms, err := batchloaders.GetByID(ctx, r.Loaders.EpisodePermissionLoader, utils.AsInt(obj.ID))
	if err != nil {
		return model.ShareRestrictionPublic, err
	}
	if lo.Contains(perms.Roles.Access, user.RolePublic) {
		return model.ShareRestrictionPublic, nil
	}
	if lo.Contains(perms.Roles.Access, user.RoleBCCMember) {
		return model.ShareRestrictionMembers, nil
	}
	if lo.Contains(perms.Roles.Access, user.RoleRegistered) {
		return model.ShareRestrictionRegistered, nil
	}
	return model.ShareRestrictionPublic, nil
}

// Image is the resolver for the image field.
func (r *seasonResolver) Image(ctx context.Context, obj *model.Season, style *model.ImageStyle) (*string, error) {
	e, err := batchloaders.GetByID(ctx, r.Loaders.SeasonLoader, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	sh, err := batchloaders.GetByID(ctx, r.Loaders.ShowLoader, e.ShowID)
	if err != nil {
		return nil, err
	}

	return imageOrFallback(ctx, e.Images, style, sh.Images), nil
}

// Show is the resolver for the show field.
func (r *seasonResolver) Show(ctx context.Context, obj *model.Season) (*model.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Episodes is the resolver for the episodes field.
func (r *seasonResolver) Episodes(ctx context.Context, obj *model.Season, first *int, offset *int, dir *string) (*model.EpisodePagination, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 64)
	if err != nil {
		return nil, err
	}

	itemIDs, err := batchloaders.GetForKey(ctx, r.FilteredLoaders(ctx).EpisodesLoader, int(intID))
	if err != nil {
		return nil, err
	}

	page := utils.Paginate(itemIDs, first, offset, dir)

	episodes, err := batchloaders.GetMany(ctx, r.Loaders.EpisodeLoader, utils.PointerIntArrayToIntArray(page.Items))
	if err != nil {
		return nil, err
	}

	return &model.EpisodePagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  utils.MapWithCtx(ctx, episodes, model.EpisodeFrom),
	}, nil
}

// Image is the resolver for the image field.
func (r *showResolver) Image(ctx context.Context, obj *model.Show, style *model.ImageStyle) (*string, error) {
	e, err := batchloaders.GetByID(ctx, r.Loaders.ShowLoader, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	return imageOrFallback(ctx, e.Images, style), nil
}

// EpisodeCount is the resolver for the episodeCount field.
func (r *showResolver) EpisodeCount(ctx context.Context, obj *model.Show) (int, error) {
	seasonIDs, err := batchloaders.GetForKey(ctx, r.FilteredLoaders(ctx).SeasonsLoader, utils.AsInt(obj.ID))
	if err != nil {
		return 0, err
	}
	el := r.FilteredLoaders(ctx).EpisodesLoader
	for _, id := range seasonIDs {
		el.Load(ctx, *id)
	}

	count := 0
	for _, id := range seasonIDs {
		episodeIDs, err := batchloaders.GetForKey(ctx, el, *id)
		if err != nil {
			return 0, err
		}
		count += len(episodeIDs)
	}
	return count, nil
}

// SeasonCount is the resolver for the seasonCount field.
func (r *showResolver) SeasonCount(ctx context.Context, obj *model.Show) (int, error) {
	seasonIDs, err := batchloaders.GetForKey(ctx, r.FilteredLoaders(ctx).SeasonsLoader, utils.AsInt(obj.ID))
	if err != nil {
		return 0, err
	}
	return len(seasonIDs), nil
}

// Seasons is the resolver for the seasons field.
func (r *showResolver) Seasons(ctx context.Context, obj *model.Show, first *int, offset *int, dir *string) (*model.SeasonPagination, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 64)
	if err != nil {
		return nil, err
	}

	itemIDs, err := batchloaders.GetForKey(ctx, r.FilteredLoaders(ctx).SeasonsLoader, int(intID))
	if err != nil {
		return nil, err
	}

	page := utils.Paginate(itemIDs, first, offset, dir)

	seasons, err := batchloaders.GetMany(ctx, r.Loaders.SeasonLoader, utils.PointerIntArrayToIntArray(page.Items))
	if err != nil {
		return nil, err
	}
	return &model.SeasonPagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  utils.MapWithCtx(ctx, seasons, model.SeasonFrom),
	}, nil
}

// DefaultEpisode is the resolver for the defaultEpisode field.
func (r *showResolver) DefaultEpisode(ctx context.Context, obj *model.Show) (*model.Episode, error) {
	s, err := batchloaders.GetByID(ctx, r.Loaders.ShowLoader, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	ls := r.FilteredLoaders(ctx)
	eID, err := show.DefaultEpisodeID(ctx, ls, s)
	if err != nil {
		return nil, err
	}
	if eID == nil {
		return nil, merry.New("invalid default episode")
	}
	return r.QueryRoot().Episode(ctx, strconv.Itoa(*eID), nil)
}

// Episode returns generated.EpisodeResolver implementation.
func (r *Resolver) Episode() generated.EpisodeResolver { return &episodeResolver{r} }

// Season returns generated.SeasonResolver implementation.
func (r *Resolver) Season() generated.SeasonResolver { return &seasonResolver{r} }

// Show returns generated.ShowResolver implementation.
func (r *Resolver) Show() generated.ShowResolver { return &showResolver{r} }

type episodeResolver struct{ *Resolver }
type seasonResolver struct{ *Resolver }
type showResolver struct{ *Resolver }
