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
	"github.com/samber/lo"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestLiveSection_NoLiveAppURL(t *testing.T) {
	// Returns before touching the request context or the DB.
	r := &Resolver{}
	e, err := r.liveSectionEntry(context.Background())
	assert.NoError(t, err)
	assert.Nil(t, e)
}

// TestLiveSection runs the live section against a database: a meeting on air
// with the stream online, and the cases where members see nothing on air.
func TestLiveSection(t *testing.T) {
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
	type state struct {
		OnAir      bool
		EventTitle *string
	}
	off := state{}
	liveSection := func(u *common.User) state {
		t.Helper()
		// A role of its own per case keeps the shared per-role loaders from
		// serving another case's (or test's) cached rows.
		cases++
		roles := []string{"bcc-members", fmt.Sprintf("%s/%d", t.Name(), cases)}
		// Start each case from the database, not from what an earlier case cached.
		memorycache.Delete("live_section:current")
		requestCache.Delete("global_config")

		r := &Resolver{
			Queries: q,
			LiveApp: liveapp.Config{BaseURL: "https://live.bcc-connect.org"},
			FilteredLoaders: func(ctx context.Context) *loaders.LoadersWithPermissions {
				return loaders.GetLoadersForRoles(q, roles)
			},
		}
		gc := &gin.Context{Request: httptest.NewRequest("POST", "/query", nil)}
		gc.Set(user.CtxUser, u)
		gc.Set(user.CtxRoles, roles)
		gc.Set(user.CtxLanguages, []string{"no"})
		rctx := utils.ContextWithGinContext(ctx, gc)
		sr := r.LiveSection()
		onAir, err := sr.OnAir(rctx, &model.LiveSection{})
		require.NoError(t, err)
		title, err := sr.EventTitle(rctx, &model.LiveSection{})
		require.NoError(t, err)
		return state{OnAir: onAir, EventTitle: title}
	}
	want := state{OnAir: true, EventTitle: lo.ToPtr("Møte")}

	assert.Equal(t, want, liveSection(member), "meeting on air")
	assert.Equal(t, off, liveSection(&common.User{ActiveBCC: false}), "not an active member")
	assert.Equal(t, off, liveSection(&common.User{Anonymous: true, ActiveBCC: true}), "anonymous")

	exec(`UPDATE globalconfig SET live_online = false`)
	assert.Equal(t, off, liveSection(member), "stream offline")
	exec(`UPDATE globalconfig SET live_online = true`)

	exec(`UPDATE calendarentries SET is_replay = true WHERE id = $1`, entryID)
	assert.Equal(t, off, liveSection(member), "rebroadcast")
	exec(`UPDATE calendarentries SET is_replay = false, link_type = 'other', episode_id = NULL WHERE id = $1`, entryID)
	assert.Equal(t, off, liveSection(member), "not a meeting")
	exec(`UPDATE calendarentries SET link_type = 'episode', episode_id = $2 WHERE id = $1`, entryID, episodeID)
	assert.Equal(t, want, liveSection(member), "meeting again")

	exec(`INSERT INTO usergroups (code, name, date_created, date_updated, explicitly_available) VALUES ('staff', 'Staff', now(), now(), false)`)
	exec(`INSERT INTO calendarentries_usergroups_buffer (calendarentries_id, usergroups_code) VALUES ($1, 'staff')`, entryID)
	assert.Equal(t, off, liveSection(member), "buffer limited to other groups")
	exec(`DELETE FROM calendarentries_usergroups_buffer WHERE calendarentries_id = $1`, entryID)

	exec(`UPDATE calendarentries SET start = start - interval '3 hours', "end" = "end" - interval '3 hours' WHERE id = $1`, entryID)
	assert.Equal(t, off, liveSection(member), "meeting over")
}
