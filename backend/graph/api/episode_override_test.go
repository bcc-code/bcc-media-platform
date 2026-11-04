package graph

import (
	"context"
	"net/http/httptest"
	"strconv"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/liveapp"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/bcc-media-platform/backend/utils/testutils"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
	"github.com/stretchr/testify/require"
)

func TestEpisodeOverrideURL(t *testing.T) {
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
		WITH mi AS (INSERT INTO mediaitems (id, label, type) VALUES (gen_random_uuid(), 'Meeting', 'video') RETURNING id),
		     tr AS (INSERT INTO mediaitems_translations (mediaitems_id, languages_code, title) SELECT id, 'no', 'Møte' FROM mi)
		INSERT INTO episodes (status, uuid, mediaitem_id) SELECT 'draft', gen_random_uuid(), mi.id FROM mi
		RETURNING id`).Scan(&episodeID))
	require.NoError(t, db.QueryRowContext(ctx, `
		INSERT INTO calendarentries (status, link_type, episode_id, start, "end")
		VALUES ('published', 'episode', $1, (now() AT TIME ZONE 'UTC') - interval '30 minutes', (now() AT TIME ZONE 'UTC') + interval '1 hour')
		RETURNING id`, episodeID).Scan(&entryID))
	exec(`INSERT INTO calendarentries_translations (calendarentries_id, languages_code, title) VALUES ($1, 'no', 'Møte')`, entryID)

	live := liveapp.Config{BaseURL: "https://live.bcc-connect.org"}
	overrideURL := func(name string) *string {
		t.Helper()
		requestCache.Delete("global_config")
		// Fresh loaders and a role of their own, so no case sees another's cache.
		roles := []string{"bcc-members", t.Name() + "/" + name}
		r := &Resolver{
			Queries: q,
			Loaders: loaders.InitBatchLoaders(q, nil),
			LiveApp: live,
			FilteredLoaders: func(ctx context.Context) *loaders.LoadersWithPermissions {
				return loaders.GetLoadersForRoles(q, roles)
			},
		}
		gc := &gin.Context{Request: httptest.NewRequest("POST", "/query", nil)}
		gc.Set(user.CtxUser, &common.User{ActiveBCC: true})
		gc.Set(user.CtxRoles, roles)
		u, err := r.Episode().OverrideURL(utils.ContextWithGinContext(ctx, gc), &model.Episode{ID: strconv.Itoa(episodeID)})
		require.NoError(t, err)
		return u
	}

	require.Equal(t, lo.ToPtr(live.RootURL()), overrideURL("on air"))

	exec(`UPDATE calendarentries SET start = start - interval '3 hours', "end" = "end" - interval '3 hours' WHERE id = $1`, entryID)
	require.Equal(t, lo.ToPtr(live.ReplayURL(entryID)), overrideURL("in buffer after end"))

	exec(`UPDATE calendarentries SET buffer_available_hours = 1 WHERE id = $1`, entryID)
	require.Nil(t, overrideURL("buffer expired"))

	exec(`UPDATE calendarentries SET buffer_available_hours = NULL, start = start + interval '1 day', "end" = "end" + interval '1 day' WHERE id = $1`, entryID)
	require.Nil(t, overrideURL("upcoming"))

	exec(`UPDATE episodes SET override_url = 'https://example.com/manual' WHERE id = $1`, episodeID)
	require.Equal(t, lo.ToPtr("https://example.com/manual"), overrideURL("manual override"))

	// The manual URL must win even while the live buffer would redirect.
	exec(`UPDATE calendarentries SET start = start - interval '1 day', "end" = "end" - interval '1 day' WHERE id = $1`, entryID)
	require.Equal(t, lo.ToPtr("https://example.com/manual"), overrideURL("manual override during meeting"))
	exec(`UPDATE episodes SET override_url = NULL WHERE id = $1`, episodeID)
	require.Equal(t, lo.ToPtr(live.ReplayURL(entryID)), overrideURL("buffer again without manual override"))
}
