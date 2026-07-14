package graph

import (
	"context"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"
)

// ctxWithUser returns a context carrying a gin.Context with the given
// languages, roles and user, as the resolvers expect.
func ctxWithUser(t *testing.T, languages []string, roles []string, u *common.User) context.Context {
	t.Helper()
	gin.SetMode(gin.TestMode)
	rec := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(rec)
	req := httptest.NewRequest("POST", "/query", nil)
	c.Request = req
	c.Set(user.CtxLanguages, languages)
	c.Set(user.CtxRoles, roles)
	c.Set(user.CtxUser, u)
	return context.WithValue(req.Context(), "GinContextKey", c)
}

func TestUserCollectionEntryItemInfo(t *testing.T) {
	now := time.Now()
	past := now.Add(-24 * time.Hour)
	future := now.Add(24 * time.Hour)

	published := common.Availability{Published: true, From: past, To: future}

	episodes := map[int]common.Episode{
		1: {ID: 1, Status: common.StatusPublished, Title: common.LocaleString{"no": nullStr("Episode én"), "en": nullStr("Episode one")}},
		2: {ID: 2, Status: common.StatusUnlisted, Title: common.LocaleString{"en": nullStr("Unlisted episode")}},
	}
	episodePermissions := map[int]common.Permissions[int]{}

	shows := map[int]common.Show{
		1: {ID: 1, Title: common.LocaleString{"en": nullStr("Show one")}},
	}
	showPermissions := map[int]common.Permissions[int]{
		1: {ItemID: 1, Availability: published, Roles: common.Roles{Access: []string{"public"}}},
	}

	episodeUUID := uuid.New()
	deletedUUID := uuid.New()
	showUUID := uuid.New()
	unlistedUUID := uuid.New()
	shortID := uuid.New()
	hiddenShortID := uuid.New()

	episodeIDMappings := map[uuid.UUID]int{
		episodeUUID:  1,
		unlistedUUID: 2,
	}
	showIDMappings := map[uuid.UUID]int{
		showUUID: 1,
	}

	shorts := map[uuid.UUID]common.Short{
		shortID:       {ID: shortID, Title: common.LocaleString{"en": nullStr("Short one")}},
		hiddenShortID: {ID: hiddenShortID, Title: common.LocaleString{"en": nullStr("Hidden short")}},
	}

	entries := map[uuid.UUID]common.UserCollectionEntry{}
	entryFor := func(itemType string, itemID uuid.UUID) uuid.UUID {
		id := uuid.New()
		entries[id] = common.UserCollectionEntry{ID: id, Type: itemType, ItemID: itemID}
		return id
	}

	episodeEntry := entryFor("episode", episodeUUID)
	deletedEntry := entryFor("episode", deletedUUID)
	unlistedEntry := entryFor("episode", unlistedUUID)
	showEntry := entryFor("show", showUUID)
	shortEntry := entryFor("short", shortID)
	hiddenShortEntry := entryFor("short", hiddenShortID)

	newResolver := func(ctx context.Context) *Resolver {
		return &Resolver{
			Loaders: &loaders.BatchLoaders{
				UserCollectionEntryLoader: loaders.New(ctx, func(_ context.Context, ids []uuid.UUID) ([]common.UserCollectionEntry, error) {
					return valuesForKeys(ids, entries), nil
				}, loaders.WithKeyFunc(func(i common.UserCollectionEntry) uuid.UUID { return i.ID })),
				EpisodeIDFromUuidLoader: mappingLoader(ctx, episodeIDMappings),
				ShowIDFromUuidLoader:    mappingLoader(ctx, showIDMappings),
				EpisodeLoader: loaders.New(ctx, func(_ context.Context, ids []int) ([]common.Episode, error) {
					return valuesForKeys(ids, episodes), nil
				}),
				ShowLoader: loaders.New(ctx, func(_ context.Context, ids []int) ([]common.Show, error) {
					return valuesForKeys(ids, shows), nil
				}),
				EpisodePermissionLoader: loaders.New(ctx, func(_ context.Context, ids []int) ([]common.Permissions[int], error) {
					return valuesForKeys(ids, episodePermissions), nil
				}, loaders.WithKeyFunc(func(p common.Permissions[int]) int { return p.ItemID })),
				ShowPermissionLoader: loaders.New(ctx, func(_ context.Context, ids []int) ([]common.Permissions[int], error) {
					return valuesForKeys(ids, showPermissions), nil
				}, loaders.WithKeyFunc(func(p common.Permissions[int]) int { return p.ItemID })),
				ShortLoader: loaders.New(ctx, func(_ context.Context, ids []uuid.UUID) ([]common.Short, error) {
					return valuesForKeys(ids, shorts), nil
				}, loaders.WithKeyFunc(func(s common.Short) uuid.UUID { return s.ID })),
			},
			FilteredLoaders: func(_ context.Context) *loaders.LoadersWithPermissions {
				return &loaders.LoadersWithPermissions{
					ShortIDsLoader: func(_ context.Context) ([][]uuid.UUID, error) {
						return [][]uuid.UUID{{shortID}}, nil
					},
				}
			},
		}
	}

	str := func(s string) *string { return &s }

	tests := []struct {
		name          string
		entryID       uuid.UUID
		permissions   common.Permissions[int]
		languages     []string
		anonymous     bool
		wantTitle     *string
		wantAvailable bool
	}{
		{
			name:          "published episode with access role is available",
			entryID:       episodeEntry,
			permissions:   common.Permissions[int]{ItemID: 1, Availability: published, Roles: common.Roles{Access: []string{"public"}}},
			wantTitle:     str("Episode one"),
			wantAvailable: true,
		},
		{
			name:          "episode with expired window keeps title, unavailable",
			entryID:       episodeEntry,
			permissions:   common.Permissions[int]{ItemID: 1, Availability: common.Availability{Published: true, From: past.Add(-time.Hour), To: past}, Roles: common.Roles{Access: []string{"public"}}},
			wantTitle:     str("Episode one"),
			wantAvailable: false,
		},
		{
			name:          "unpublished episode keeps title, unavailable",
			entryID:       episodeEntry,
			permissions:   common.Permissions[int]{ItemID: 1, Availability: common.Availability{Published: false, From: past, To: future}, Roles: common.Roles{Access: []string{"public"}}},
			wantTitle:     str("Episode one"),
			wantAvailable: false,
		},
		{
			name:          "episode with role mismatch keeps title, unavailable",
			entryID:       episodeEntry,
			permissions:   common.Permissions[int]{ItemID: 1, Availability: published, Roles: common.Roles{Access: []string{"members-only"}}},
			wantTitle:     str("Episode one"),
			wantAvailable: false,
		},
		{
			name:          "episode not yet started keeps title, unavailable",
			entryID:       episodeEntry,
			permissions:   common.Permissions[int]{ItemID: 1, Availability: common.Availability{Published: true, From: future, To: future.Add(time.Hour)}, Roles: common.Roles{Access: []string{"public"}}},
			wantTitle:     str("Episode one"),
			wantAvailable: false,
		},
		{
			name:          "deleted episode has no title",
			entryID:       deletedEntry,
			wantTitle:     nil,
			wantAvailable: false,
		},
		{
			name:          "unlisted episode is unavailable for anonymous user",
			entryID:       unlistedEntry,
			permissions:   common.Permissions[int]{ItemID: 2, Availability: common.Availability{Unlisted: true, From: past, To: future}, Roles: common.Roles{Access: []string{"public"}}},
			anonymous:     true,
			wantTitle:     str("Unlisted episode"),
			wantAvailable: false,
		},
		{
			name:          "unlisted episode is available for authenticated user",
			entryID:       unlistedEntry,
			permissions:   common.Permissions[int]{ItemID: 2, Availability: common.Availability{Unlisted: true, From: past, To: future}, Roles: common.Roles{Access: []string{"public"}}},
			wantTitle:     str("Unlisted episode"),
			wantAvailable: true,
		},
		{
			name:          "show with access is available",
			entryID:       showEntry,
			wantTitle:     str("Show one"),
			wantAvailable: true,
		},
		{
			name:          "short in filtered ids is available",
			entryID:       shortEntry,
			wantTitle:     str("Short one"),
			wantAvailable: true,
		},
		{
			name:          "short outside filtered ids keeps title, unavailable",
			entryID:       hiddenShortEntry,
			wantTitle:     str("Hidden short"),
			wantAvailable: false,
		},
		{
			name:          "title is localized",
			entryID:       episodeEntry,
			permissions:   common.Permissions[int]{ItemID: 1, Availability: published, Roles: common.Roles{Access: []string{"public"}}},
			languages:     []string{"no"},
			wantTitle:     str("Episode én"),
			wantAvailable: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			languages := tt.languages
			if languages == nil {
				languages = []string{"en"}
			}
			ctx := ctxWithUser(t, languages, []string{"public"}, &common.User{Anonymous: tt.anonymous})
			episodePermissions[tt.permissions.ItemID] = tt.permissions
			r := newResolver(ctx)

			title, available, err := r.userCollectionEntryItemInfo(ctx, tt.entryID.String())

			assert.NoError(t, err)
			assert.Equal(t, tt.wantTitle, title)
			assert.Equal(t, tt.wantAvailable, available)
		})
	}
}

func nullStr(s string) null.String {
	return null.StringFrom(s)
}

func valuesForKeys[K comparable, V any](keys []K, m map[K]V) []V {
	var out []V
	for _, k := range keys {
		if v, ok := m[k]; ok {
			out = append(out, v)
		}
	}
	return out
}

func mappingLoader(ctx context.Context, m map[uuid.UUID]int) *loaders.Loader[uuid.UUID, *common.Mapping[uuid.UUID, int]] {
	return loaders.New(ctx, func(_ context.Context, ids []uuid.UUID) ([]common.Mapping[uuid.UUID, int], error) {
		var out []common.Mapping[uuid.UUID, int]
		for _, id := range ids {
			if v, ok := m[id]; ok {
				out = append(out, common.Mapping[uuid.UUID, int]{Key: id, Value: v})
			}
		}
		return out, nil
	})
}
