package user

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils/testutils"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
	"time"
)

// Define context keys for testing
const (
	CtxGinKey string = "gin-context"
)

func TestValidateAccess(t *testing.T) {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
	db := testutils.NewDB(t)
	q := sqlc.New(db)

	ctx := context.Background()

	err := testutils.InsertDefaults(ctx, q)
	assert.NoError(t, err)

	appGroup := testutils.CreateAppGroup(t, ctx, q)

	// Create a test user and profile
	testutils.CreateProfile(t, ctx, q, testutils.DefaultBCCUser, appGroup)
	_, err = q.ApplicationQueries(appGroup).GetProfilesForUserIDs(ctx, []string{testutils.DefaultBCCUser})
	assert.NoError(t, err)

	// Create test data
	now := time.Now()
	itemID := 1

	tests := []struct {
		name       string
		roles      []string
		perms      common.Permissions[int]
		conditions CheckConditions
		expectErr  bool
		errType    error
	}{
		{
			name:  "Access granted with matching role",
			roles: []string{"test-role"},
			perms: common.Permissions[int]{
				Roles: common.Roles{
					Access: []string{"test-role"},
				},
				Availability: common.Availability{
					Published: true,
					From:      now.Add(-time.Hour),
					To:        now.Add(time.Hour),
				},
			},
			conditions: CheckConditions{},
			expectErr:  false,
		},
		{
			name:  "Access denied with no matching role",
			roles: []string{"other-role"},
			perms: common.Permissions[int]{
				Roles: common.Roles{
					Access: []string{"test-role"},
				},
				Availability: common.Availability{
					Published: true,
					From:      now.Add(-time.Hour),
					To:        now.Add(time.Hour),
				},
			},
			conditions: CheckConditions{},
			expectErr:  true,
			errType:    common.ErrItemNoAccess,
		},
		{
			name:  "Early access with matching role",
			roles: []string{"early-access"},
			perms: common.Permissions[int]{
				Roles: common.Roles{
					EarlyAccess: []string{"early-access"},
				},
				Availability: common.Availability{
					Published: true,
					From:      now.Add(-time.Hour),
					To:        now.Add(time.Hour),
				},
			},
			conditions: CheckConditions{},
			expectErr:  false,
		},
		{
			name:  "Item not published",
			roles: []string{"test-role"},
			perms: common.Permissions[int]{
				Roles: common.Roles{
					Access: []string{"test-role"},
				},
				Availability: common.Availability{
					Published: false,
					From:      now.Add(-time.Hour),
					To:        now.Add(time.Hour),
				},
			},
			conditions: CheckConditions{},
			expectErr:  true,
			errType:    common.ErrItemNotPublished,
		},
		{
			name:  "Publish date in future",
			roles: []string{"test-role"},
			perms: common.Permissions[int]{
				Roles: common.Roles{
					Access: []string{"test-role"},
				},
				Availability: common.Availability{
					Published:   true,
					From:        now.Add(-time.Hour),
					To:          now.Add(time.Hour),
					PublishedOn: now.Add(time.Hour),
				},
			},
			conditions: CheckConditions{
				PublishDate: true,
			},
			expectErr: true,
			errType:   ErrPublishDateInFuture,
		},
		{
			name:  "Unlisted episode with matching role",
			roles: []string{"test-role"},
			perms: common.Permissions[int]{
				Roles: common.Roles{
					Access: []string{"test-role"},
				},
				Availability: common.Availability{
					Published: false,
					Unlisted:  true,
					From:      now.Add(-time.Hour),
					To:        now.Add(time.Hour),
				},
			},
			conditions: CheckConditions{},
			expectErr:  false,
		},
		{
			name:  "Unlisted episode with early access",
			roles: []string{"early-access"},
			perms: common.Permissions[int]{
				Roles: common.Roles{
					EarlyAccess: []string{"early-access"},
				},
				Availability: common.Availability{
					Published: false,
					Unlisted:  true,
					From:      now.Add(-time.Hour),
					To:        now.Add(time.Hour),
				},
			},
			conditions: CheckConditions{},
			expectErr:  false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Create a test context with the roles
			w := httptest.NewRecorder()
			c, _ := gin.CreateTestContext(w)
			c.Set("userRoles", tt.roles)

			ctx = context.WithValue(ctx, CtxGinKey, c)

			// Create a permission loader that returns our test permissions
			permissionLoader := loaders.New(ctx, func(ctx context.Context, keys []int) ([]common.Permissions[int], error) {
				result := make([]common.Permissions[int], len(keys))
				for i := range keys {
					if keys[i] == itemID {
						// Set the ItemID in the permissions struct
						perms := tt.perms
						perms.ItemID = keys[i]
						result[i] = perms
					}
				}
				return result, nil
			}, loaders.WithKeyFunc(func(p common.Permissions[int]) int {
				return p.ItemID
			}))

			err := ValidateAccess(ctx, permissionLoader, itemID, tt.conditions)

			if tt.expectErr {
				assert.Error(t, err)
				if tt.errType != nil {
					assert.ErrorIs(t, err, tt.errType)
				}
			} else {
				assert.NoError(t, err)
			}
		})
	}
}
