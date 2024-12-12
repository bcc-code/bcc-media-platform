package notifications

import (
	"context"
	"flag"
	"os"
	"testing"

	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	_ "github.com/lib/pq"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
)

var pushNotificationsTestEnabled = false

func TestMain(m *testing.M) {
	flag.BoolVar(&pushNotificationsTestEnabled, "push", false, "Enable push notifications tests (Requires local DB server with data)")
	flag.Parse()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	os.Exit(m.Run())
}

func TestResolveTargets(t *testing.T) {
	if !pushNotificationsTestEnabled {
		t.Skip("Push notification tests are disabled")
	}

	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	ctx := context.Background()

	db, _ := utils.MustCreateDBClient(ctx, utils.DatabaseConfig{
		ConnectionString: "postgresql://bccm:bccm123@localhost:5432/bccm?sslmode=disable",
	})

	if db == nil {
		t.Fatal("Could not connect to the database")
	}

	queries := sqlc.New(db)
	utils := NewUtils(queries)

	// Note: This is local data that needs to be adjusted for this test to make any real sense
	// It was built primarily so it was easy to compare the old and the new implementation
	res, err := utils.ResolveTargets(ctx, uuid.MustParse("98f23cf0-7de1-4868-9343-0f6b5d39941b"), []uuid.UUID{
		uuid.MustParse("e2ddc055-b917-4007-ac93-e50fa584ea9e"),
	})
	assert.NoError(t, err)
	assert.Len(t, res, 1)
}
