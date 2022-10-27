package graph

import (
	"context"
	"fmt"
	"github.com/99designs/gqlgen/graphql"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/memorycache"
	"gopkg.in/guregu/null.v4"
	"strconv"
	"sync"
	"time"

	"go.opentelemetry.io/otel"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/signing"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/graph-gophers/dataloader/v7"
	"github.com/samber/lo"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

// Resolver is the main struct for the GQL implementation
// It contains references to all external services and config
type Resolver struct {
	Queries         *sqlc.Queries
	Loaders         *common.BatchLoaders
	FilteredLoaders func(ctx context.Context) *common.FilteredLoaders
	ProfileLoaders  func(ctx context.Context) *common.ProfileLoaders
	SearchService   *search.Service
	URLSigner       *signing.Signer
	APIConfig       apiConfig
	S3Client        *s3.Client
	AWSConfig       awsConfig
}

func (r *Resolver) GetQueries() *sqlc.Queries {
	return r.Queries
}

func (r *Resolver) GetLoaders() *common.BatchLoaders {
	return r.Loaders
}

func (r *Resolver) GetFilteredLoaders(ctx context.Context) *common.FilteredLoaders {
	return r.FilteredLoaders(ctx)
}

func (r *Resolver) GetS3Client() *s3.Client {
	return r.S3Client
}

type awsConfig interface {
	GetTempStorageBucket() string
}

type apiConfig interface {
	GetVOD2Domain() string
	GetFilesCDNDomain() string
	GetLegacyVODDomain() string
}

// ErrItemNotFound for not found items
var (
	ErrItemNotFound  = merry.Sentinel("item not found")
	ErrProfileNotSet = merry.Sentinel("profile not set", merry.WithUserMessage("must be logged in for this function"))
)

var requestLocks = map[string]*sync.Mutex{}
var requestCache = cache.New[string, any]()

func withCache[r any](ctx context.Context, key string, factory func(ctx context.Context) (r, error), expiry time.Duration) (r, error) {
	ctx, span := otel.Tracer("cache").Start(ctx, "simple")
	defer span.End()
	if result, ok := requestCache.Get(key); ok {
		return result.(r), nil
	}

	lock, ok := requestLocks[key]
	if !ok {
		lock = &sync.Mutex{}
		requestLocks[key] = lock
	}
	lock.Lock()
	defer lock.Unlock()

	if result, ok := requestCache.Get(key); ok {
		return result.(r), nil
	}

	result, err := factory(ctx)
	if err != nil {
		// probably not the correct way to do this
		return result, err
	}

	requestCache.Set(key, result, cache.WithExpiration(expiry))

	return result, nil
}

type timedCacheEntry[t any] struct {
	Cached time.Time
	Entry  t
}

var truncateTime = time.Second * 1

func withCacheAndTimestamp[r any](ctx context.Context, key string, factory func(ctx context.Context) (r, error), expiry time.Duration, timestamp *string) (r, error) {
	ctx, span := otel.Tracer("cache").Start(ctx, "with-timestamp")
	defer span.End()
	ts, err := timestampFromString(timestamp)
	if err != nil {
		var result r
		return result, err
	}
	if ts != nil {
		now := time.Now()
		if ts.After(now) {
			ts = &now
		}
		truncated := ts.Truncate(truncateTime)
		ts = &truncated
	}

	var entry timedCacheEntry[r]
	if result, ok := requestCache.Get(key); ok {
		if entry, ok = result.(timedCacheEntry[r]); ok {
			if ts == nil || entry.Cached.Equal(*ts) || entry.Cached.After(*ts) {
				return entry.Entry, nil
			}
		}
	}

	lock, ok := requestLocks[key]
	if !ok {
		lock = &sync.Mutex{}
		requestLocks[key] = lock
	}
	lock.Lock()
	defer lock.Unlock()

	if result, ok := requestCache.Get(key); ok {
		if entry, ok = result.(timedCacheEntry[r]); ok {
			if ts == nil || entry.Cached.Equal(*ts) || entry.Cached.After(*ts) {
				return entry.Entry, nil
			}
		}
	}

	item, err := factory(ctx)
	if err != nil {
		return entry.Entry, err
	}
	entry = timedCacheEntry[r]{
		Cached: time.Now().Truncate(truncateTime),
		Entry:  item,
	}
	requestCache.Set(key, entry, cache.WithExpiration(expiry))

	return entry.Entry, nil
}

func timestampFromString(timestamp *string) (*time.Time, error) {
	var r *time.Time
	if timestamp != nil {
		t, err := time.Parse(time.RFC3339, *timestamp)
		if err != nil {
			return nil, err
		}
		r = &t
	}
	return r, nil
}

type itemLoaders[k comparable, t any] struct {
	Permissions *dataloader.Loader[k, *common.Permissions[k]]
	Item        *dataloader.Loader[k, *t]
}

// resolverFor returns a resolver for the specified item
func resolverFor[k comparable, t any, r any](ctx context.Context, loaders *itemLoaders[k, t], id k, converter func(context.Context, *t) r) (res r, err error) {
	ctx, span := otel.Tracer("resolver").Start(ctx, "item")
	defer span.End()
	obj, err := batchloaders.GetByID(ctx, loaders.Item, id)
	if err != nil {
		return res, err
	}
	if obj == nil {
		return res, merry.Wrap(ErrItemNotFound)
	}

	if t, ok := any(obj).(batchloaders.HasKey[k]); ok && loaders.Permissions != nil {
		err = user.ValidateAccess(ctx, loaders.Permissions, t.GetKey())
		if err != nil {
			return res, err
		}
	}

	return converter(ctx, obj), nil
}

// resolverForIntID returns a resolver for items with ints as keys
func resolverForIntID[t any, r any](ctx context.Context, loaders *itemLoaders[int, t], id string, converter func(context.Context, *t) r) (res r, err error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return res, err
	}

	return resolverFor(ctx, loaders, int(intID), converter)
}

func itemsResolverFor[k comparable, kr comparable, t any, r any](ctx context.Context, loaders *itemLoaders[k, t], listLoader *dataloader.Loader[kr, []*k], id kr, converter func(context.Context, *t) r) ([]r, error) {
	ctx, span := otel.Tracer("resolver").Start(ctx, "items")
	defer span.End()
	itemIds, err := batchloaders.GetForKey(ctx, listLoader, id)
	if err != nil {
		return nil, err
	}

	ids := lo.Map(lo.Filter(itemIds, func(i *k, _ int) bool {
		if loaders.Permissions != nil {
			return user.ValidateAccess(ctx, loaders.Permissions, *i) == nil
		}
		return true
	}), func(i *k, _ int) k {
		return *i
	})

	items, err := batchloaders.GetMany(ctx, loaders.Item, ids)

	return utils.MapWithCtx(ctx, items, converter), err
}

func itemsResolverForIntID[t any, r any](ctx context.Context, loaders *itemLoaders[int, t], listLoader *dataloader.Loader[int, []*int], id string, converter func(context.Context, *t) r) ([]r, error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return nil, err
	}
	return itemsResolverFor(ctx, loaders, listLoader, int(intID), converter)
}

func imageOrFallback(ctx context.Context, images common.Images, fallback null.String, style *model.ImageStyle) *string {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	s := "default"
	if style != nil && style.IsValid() {
		s = style.String()
	}
	img := images.GetDefault(languages, s)
	if img == nil && s != "icon" && fallback.Valid {
		img = &fallback.String
	}
	return img
}

func messageStyleFromString(styleString string) *model.MessageStyle {
	style := &model.MessageStyle{}
	switch styleString {
	case "error":
		style.Background = "#bf3b32"
		style.Text = "#ffffff"
		style.Border = "#8c2b24"
	case "info":
		style.Background = "#133747"
		style.Border = "#1f5770"
		style.Text = "#ffffff"
	case "warning":
		style.Border = "#ff9408"
		style.Background = "#633800"
		style.Text = "#ffffff"
	default:
		style.Background = "#133747"
		style.Border = "#1f5770"
		style.Text = "#ffffff"
	}
	return style
}

func resolveMessageSection(ctx context.Context, r *messageSectionResolver, s *common.Section) ([]*model.Message, error) {
	var timestamp *string
	fieldCtx := graphql.GetRootFieldContext(ctx)
	for _, a := range fieldCtx.Field.Arguments {
		if a.Name == "timestamp" && a.Value.Raw != "null" {
			timestamp = &a.Value.Raw
		}
	}

	t, err := utils.TimestampFromString(timestamp)
	if err != nil {
		return nil, err
	}
	if t != nil {
		now := time.Now()
		if t.After(now) {
			t = &now
		}
		truncated := t.Truncate(truncateTime)
		t = &truncated
	}

	if t != nil {
		// This code should just clear the cached entry from loader
		// in case the specified timestamp is later than the stored.
		key := fmt.Sprintf("section:%d:message_group", s.ID)
		stored := memorycache.Get[time.Time](key)
		if stored == nil || stored.Before(t.Truncate(truncateTime)) {
			r.Loaders.MessageGroupLoader.Clear(ctx, int(s.MessageID.Int64))
			now := time.Now().Truncate(truncateTime)
			memorycache.Set(key, &now, cache.WithExpiration(time.Minute*5))
		}
	}

	group, err := batchloaders.GetByID(ctx, r.Loaders.MessageGroupLoader, int(s.MessageID.Int64))
	if err != nil {
		return nil, err
	}

	if group == nil || !group.Enabled {
		return nil, nil
	}

	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	languages := user.GetLanguagesFromCtx(ginCtx)

	return lo.Map(group.Messages, func(i common.Message, _ int) *model.Message {
		return &model.Message{
			Style:   messageStyleFromString(i.Style),
			Title:   i.Title.Get(languages),
			Content: i.Content.Get(languages),
		}
	}), nil
}
