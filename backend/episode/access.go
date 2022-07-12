package episode

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
)

// ValidateAccess returns an error if this episode is not accessible for the user in the context
func ValidateAccess(ctx context.Context, episode sqlc.EpisodeExpanded) error {
	return user.ValidateAccess(ctx, episode)
}
