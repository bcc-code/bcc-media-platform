package graph

import (
	"context"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/liveapp"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/bcc-media-platform/backend/utils/testutils"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestBanner_UnknownSource(t *testing.T) {
	r := &Resolver{}
	b, err := r.banner(context.Background(), model.BannerSource("unknown"))
	assert.NoError(t, err)
	assert.Nil(t, b)
}

func TestLiveBanner_NoLiveAppURL(t *testing.T) {
	// Returns before touching the request context or the DB.
	r := &Resolver{}
	b, err := r.liveBanner(context.Background())
	assert.NoError(t, err)
	assert.Nil(t, b)
}

// TestLiveBanner runs the live source against a database: a meeting on air
// with the stream online, and the cases where members get no banner.
func TestLiveBanner(t *testing.T) {
	db := testutils.NewDB(t)
	ctx := context.Background()
	q := sqlc.New(db)
	require.NoError(t, testutils.InsertDefaults(ctx, q))

	exec := func(query string, args ...any) {
		t.Helper()
		_, err := db.ExecContext(ctx, query, args...)
		require.NoError(t, err)
	}
	exec(`INSERT INTO globalconfig (live_online, date_updated, user_updated) VALUES (true, now(), $1)`, testutils.DefaultUser)
	var entryID int
	require.NoError(t, db.QueryRowContext(ctx, `
		INSERT INTO calendarentries (status, start, "end")
		VALUES ('published', (now() AT TIME ZONE 'UTC') - interval '30 minutes', (now() AT TIME ZONE 'UTC') + interval '1 hour')
		RETURNING id`).Scan(&entryID))
	exec(`INSERT INTO calendarentries_translations (calendarentries_id, languages_code, title) VALUES ($1, 'no', 'Møte')`, entryID)

	// A role of its own keeps the shared per-role loaders from serving another
	// test's database.
	roles := []string{"bcc-members", t.Name()}
	member := &common.User{ActiveBCC: true}

	liveBanner := func(baseURL string, u *common.User) *model.Banner {
		t.Helper()
		// Start each case from the database, not from what an earlier case cached.
		memorycache.Delete("live_banner:current")
		requestCache.Delete("global_config")

		r := &Resolver{
			Queries: q,
			LiveApp: liveapp.Config{BaseURL: baseURL},
			FilteredLoaders: func(ctx context.Context) *loaders.LoadersWithPermissions {
				return loaders.GetLoadersForRoles(q, roles)
			},
		}
		gc := &gin.Context{}
		gc.Set(user.CtxUser, u)
		gc.Set(user.CtxRoles, roles)
		gc.Set(user.CtxLanguages, []string{"no"})
		b, err := r.liveBanner(utils.ContextWithGinContext(ctx, gc))
		require.NoError(t, err)
		return b
	}
	want := &model.Banner{Title: "Møte", URL: "https://live.bcc-connect.org/"}

	assert.Equal(t, want, liveBanner("https://live.bcc-connect.org", member), "meeting on air")
	assert.Equal(t, want, liveBanner("https://live.bcc-connect.org/", member), "base URL with trailing slash")
	assert.Nil(t, liveBanner("https://live.bcc-connect.org", &common.User{ActiveBCC: false}), "not an active member")
	assert.Nil(t, liveBanner("https://live.bcc-connect.org", &common.User{Anonymous: true, ActiveBCC: true}), "anonymous")

	exec(`UPDATE globalconfig SET live_online = false`)
	assert.Nil(t, liveBanner("https://live.bcc-connect.org", member), "stream offline")
	exec(`UPDATE globalconfig SET live_online = true`)

	exec(`UPDATE calendarentries SET start = start - interval '3 hours', "end" = "end" - interval '3 hours' WHERE id = $1`, entryID)
	assert.Nil(t, liveBanner("https://live.bcc-connect.org", member), "meeting over")
}
