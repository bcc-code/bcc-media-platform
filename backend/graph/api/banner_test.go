package graph

import (
	"context"
	"fmt"
	"net/http/httptest"
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
	exec(`INSERT INTO globalconfig (live_online, livestream_url, date_updated, user_updated) VALUES (true, 'https://example.com/live.m3u8', now(), $1)`, testutils.DefaultUser)
	var episodeID, entryID int
	require.NoError(t, db.QueryRowContext(ctx, `
		WITH mi AS (INSERT INTO mediaitems (id, label, type) VALUES (gen_random_uuid(), 'Meeting', 'video') RETURNING id)
		INSERT INTO episodes (status, uuid, mediaitem_id) SELECT 'draft', gen_random_uuid(), mi.id FROM mi
		RETURNING id`).Scan(&episodeID))
	require.NoError(t, db.QueryRowContext(ctx, `
		INSERT INTO calendarentries (status, link_type, episode_id, start, "end")
		VALUES ('published', 'episode', $1, (now() AT TIME ZONE 'UTC') - interval '30 minutes', (now() AT TIME ZONE 'UTC') + interval '1 hour')
		RETURNING id`, episodeID).Scan(&entryID))
	exec(`INSERT INTO calendarentries_translations (calendarentries_id, languages_code, title) VALUES ($1, 'no', 'Møte')`, entryID)

	member := &common.User{ActiveBCC: true}

	cases := 0
	liveBanner := func(baseURL string, u *common.User) *model.Banner {
		t.Helper()
		// A role of its own per case keeps the shared per-role loaders from
		// serving another case's (or test's) cached rows.
		cases++
		roles := []string{"bcc-members", fmt.Sprintf("%s/%d", t.Name(), cases)}
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
		gc := &gin.Context{Request: httptest.NewRequest("POST", "/query", nil)}
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

	exec(`UPDATE calendarentries SET is_replay = true WHERE id = $1`, entryID)
	assert.Nil(t, liveBanner("https://live.bcc-connect.org", member), "rebroadcast")
	exec(`UPDATE calendarentries SET is_replay = false, link_type = 'other', episode_id = NULL WHERE id = $1`, entryID)
	assert.Nil(t, liveBanner("https://live.bcc-connect.org", member), "not a meeting")
	exec(`UPDATE calendarentries SET link_type = 'episode', episode_id = $2 WHERE id = $1`, entryID, episodeID)
	assert.Equal(t, want, liveBanner("https://live.bcc-connect.org", member), "meeting again")

	exec(`INSERT INTO usergroups (code, name, date_created, date_updated, explicitly_available) VALUES ('staff', 'Staff', now(), now(), false)`)
	exec(`INSERT INTO calendarentries_usergroups_buffer (calendarentries_id, usergroups_code) VALUES ($1, 'staff')`, entryID)
	assert.Nil(t, liveBanner("https://live.bcc-connect.org", member), "buffer limited to other groups")
	exec(`DELETE FROM calendarentries_usergroups_buffer WHERE calendarentries_id = $1`, entryID)

	exec(`UPDATE calendarentries SET start = start - interval '3 hours', "end" = "end" - interval '3 hours' WHERE id = $1`, entryID)
	assert.Nil(t, liveBanner("https://live.bcc-connect.org", member), "meeting over")
}
