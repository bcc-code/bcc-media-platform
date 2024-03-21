package graph

import (
	"context"
	"crypto/rsa"
	"fmt"
	"strconv"
	"sync"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"

	"github.com/bcc-code/bcc-media-platform/backend/ratelimit"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/cloudevents/sdk-go/v2/event/datacodec/json"
	"github.com/google/uuid"
	"github.com/sqlc-dev/pqtype"

	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/email"
	"github.com/bcc-code/bcc-media-platform/backend/export"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/otel"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

const timestampContextKey = "GqlTimestamp"

const episodeContextKey = "EpisodeContext"

type searchProvider interface {
	Search(ctx *gin.Context, query common.SearchQuery, userToken string) (searchResult common.SearchResult, err error)
}

// Resolver is the main struct for the GQL implementation
// It contains references to all external services and config
type Resolver struct {
	Queries            *sqlc.Queries
	Loaders            *common.BatchLoaders
	FilteredLoaders    func(ctx context.Context) *common.FilteredLoaders
	ProfileLoaders     func(ctx context.Context) *common.ProfileLoaders
	SearchService      searchProvider
	EmailService       *email.Service
	URLSigner          *signing.Signer
	S3Client           *s3.Client
	APIConfig          apiConfig
	AWSConfig          awsConfig
	AnalyticsIDFactory func(ctx context.Context) string
	RedirectConfig     redirectConfig
	AuthClient         *auth0.Client
	RemoteCache        *remotecache.Client
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

func (r *Resolver) GetProfileLoaders(ctx context.Context) *common.ProfileLoaders {
	return r.ProfileLoaders(ctx)
}

func (r *Resolver) GetS3Client() *s3.Client {
	return r.S3Client
}

func (r *Resolver) GetURLSigner() *signing.Signer {
	return r.URLSigner
}

func (r *Resolver) GetCDNConfig() export.CDNConfig {
	return r.APIConfig
}

type awsConfig interface {
	GetTempStorageBucket() string
}

type apiConfig interface {
	GetVOD2Domain() string
	GetFilesCDNDomain() string
	GetLegacyVODDomain() string
}

type redirectConfig interface {
	GetPrivateKey() *rsa.PrivateKey
}

// Errors
var (
	ErrItemNotFound  = common.ErrItemNotFound
	ErrProfileNotSet = common.ErrProfileNotSet
)

var requestLocks = map[string]*sync.Mutex{}
var requestCache = cache.New[string, any]()

type timedCacheEntry[t any] struct {
	Cached time.Time
	Entry  t
}

var truncateTime = time.Second * 1

func withCacheAndTimestamp[r any](ctx context.Context, key string, factory func(ctx context.Context) (r, error), expiry time.Duration, timestamp *string) (r, error) {
	ctx, span := otel.Tracer("cache").Start(ctx, "with-timestamp")
	defer span.End()
	ts, err := utils.TimestampFromString(timestamp)
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

type itemLoaders[k comparable, t any] struct {
	Permissions *loaders.Loader[k, *common.Permissions[k]]
	Item        *loaders.Loader[k, *t]
}

// resolverFor returns a resolver for the specified item
func resolverFor[k comparable, t any, r any](ctx context.Context, ls *itemLoaders[k, t], id k, converter func(context.Context, *t) r) (res r, err error) {
	ctx, span := otel.Tracer("resolver").Start(ctx, "item")
	defer span.End()
	obj, err := ls.Item.Get(ctx, id)
	if err != nil {
		return res, err
	}
	if obj == nil {
		return res, merry.Wrap(ErrItemNotFound)
	}

	if t, ok := any(obj).(loaders.HasKey[k]); ok && ls.Permissions != nil {
		err = user.ValidateAccess(ctx, ls.Permissions, t.GetKey(), user.CheckConditions{
			FromDate: true,
		})
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

func imageOrFallback(ctx context.Context, images common.Images, style *model.ImageStyle, fallbacks ...common.Images) *string {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	s := "default"
	if style != nil && style.IsValid() {
		s = style.String()
	}
	img := images.GetStrict(languages, s)
	if img == nil {
		for _, fb := range fallbacks {
			img = fb.GetStrict(languages, s)
			if img != nil {
				break
			}
		}
	}
	if img == nil && s != "default" {
		s = "default"
		img = images.GetStrict(languages, s)
	}
	if img == nil {
		for _, fb := range fallbacks {
			img = fb.GetStrict(languages, s)
			if img != nil {
				break
			}
		}
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
		style.Background = "#6EB0E6"
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

	ginCtx, _ := utils.GinCtx(ctx)
	timestamp := ginCtx.GetString(timestampContextKey)
	var timestampPointer *string
	if timestamp != "" {
		timestampPointer = &timestamp
	}

	t, err := utils.TimestampFromString(timestampPointer)
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
		stored, success := memorycache.Get[time.Time](key)
		if !success || stored.Before(t.Truncate(truncateTime)) {
			r.Loaders.MessageGroupLoader.Clear(ctx, int(s.MessageID.Int64))
			now := time.Now().Truncate(truncateTime)
			memorycache.Set(key, &now, cache.WithExpiration(time.Minute*5))
		}
	}

	group, err := r.Loaders.MessageGroupLoader.Get(ctx, int(s.MessageID.Int64))
	if err != nil {
		return nil, err
	}

	if group == nil || !group.Enabled {
		return nil, nil
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

func getProfile(ctx context.Context) (*common.Profile, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	p := user.GetProfileFromCtx(ginCtx)
	if p == nil {
		return nil, ErrProfileNotSet
	}
	return p, nil
}

func getTask(ctx context.Context, resolver *Resolver, taskID string) (*common.Task, error) {
	uid, err := uuid.Parse(taskID)
	if err != nil {
		return nil, err
	}
	task, err := resolver.Loaders.StudyTaskLoader.Get(ctx, uid)
	if err != nil {
		return nil, err
	}
	if task == nil {
		return nil, ErrItemNotFound
	}
	return task, nil
}

func getEpisode(ctx context.Context, resolver *Resolver, episodeID string) (*common.Episode, error) {
	id, err := strconv.ParseInt(episodeID, 10, 64)
	if err != nil {
		return nil, err
	}
	episode, err := resolver.Loaders.EpisodeLoader.Get(ctx, int(id))
	if err != nil {
		return nil, err
	}
	if episode == nil {
		return nil, ErrItemNotFound
	}
	return episode, nil
}

func (r *Resolver) sendMessage(ctx context.Context, itemID uuid.UUID, message *string, metadata map[string]any) (string, error) {
	err := ratelimit.Endpoint(ctx, "messages:send:"+itemID.String(), 2, false)
	if err != nil {
		return "", err
	}
	id := utils.GenerateRandomSecureString(32)
	var str string
	if message != nil {
		str = *message
	}

	var md pqtype.NullRawMessage
	if metadata != nil {
		md.RawMessage, err = json.Encode(ctx, metadata)
		md.Valid = err == nil
	}

	insertParams := sqlc.UpsertMessageParams{
		ID:       id,
		Message:  str,
		ItemID:   itemID,
		Metadata: md,
	}

	gc, err := utils.GinCtx(ctx)
	if err != nil {
		log.L.Warn().Err(err).Msg("sendMessage is unable to get GinCtx")
	} else {
		usr := user.GetFromCtx(gc)
		if len(usr.ChurchIDs) > 0 {
			insertParams.OrgID = int32(usr.ChurchIDs[0])
		}
		insertParams.AgeGroup = usr.AgeGroup
	}

	err = r.Queries.UpsertMessage(ctx, insertParams)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to save string to database")
		return "", merry.New("Failed to generate unique ID")
	}
	return id, nil
}

func (r *Resolver) updateMessage(ctx context.Context, id string, message *string, metadata map[string]any) (string, error) {
	err := ratelimit.Endpoint(ctx, "messages:update", 100, false)
	if err != nil {
		return "", err
	}
	var str string
	if message != nil {
		str = *message
	}
	var md pqtype.NullRawMessage
	if metadata != nil {
		md.RawMessage, err = json.Encode(ctx, metadata)
		md.Valid = err != nil
	}
	err = r.Queries.UpdateMessage(ctx, sqlc.UpdateMessageParams{
		ID:       id,
		Message:  str,
		Metadata: md,
	})
	if err != nil {
		return "", err
	}
	return id, err
}

func (r *Resolver) getUserInfo(ctx context.Context, userID string) (auth0.UserInfo, error) {
	return memorycache.GetOrSet(ctx, "userinfo:"+userID, func(ctx context.Context) (auth0.UserInfo, error) {
		ginCtx, _ := utils.GinCtx(ctx)
		info, err := r.AuthClient.GetUser(ctx, ginCtx.GetString(auth0.CtxUserID))
		if err != nil {
			return auth0.UserInfo{}, err
		}
		return info, nil
	}, cache.WithExpiration(time.Second*2))
}

func uuidItemLoader[T any, R any](
	ctx context.Context,
	loader *loaders.Loader[uuid.UUID, *T],
	converter func(context.Context, *T) *R,
	idString string) (*R, error) {
	return itemLoader(ctx, loader, converter, uuid.Parse, idString)
}

func itemLoader[K comparable, T any, R any](
	ctx context.Context,
	loader *loaders.Loader[K, *T],
	converter func(context.Context, *T) *R,
	idValidator func(i string) (K, error),
	idString string,
) (*R, error) {
	uid, err := idValidator(idString)
	if err != nil {
		return nil, err
	}
	i, err := loader.Get(ctx, uid)
	if err != nil {
		return nil, err
	}
	if i == nil {
		return nil, ErrItemNotFound
	}
	return converter(ctx, i), nil
}
