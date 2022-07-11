package episode

import (
	"context"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

var errEpisodeNotPublished = merry.Sentinel("Selected episode is not published yet")
var errEpisodeNoAccess = merry.Sentinel("The user does not have access to this episode")

// ValidateAccess returns an error if this episode is not accessible for the user in the context
func ValidateAccess(ctx context.Context, episode sqlc.EpisodeExpanded) error {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return err
	}
	u := user.GetFromCtx(ginCtx)

	// This is a bit dense so here is a text version:
	// * If the user has early access -> Continue
	// * Else Check if the episode is published (status) and in the correct timeframe
	if len(lo.Intersect(u.Roles, episode.EarlyAccessGroups)) == 0 && (!episode.Published ||
		episode.AvailableFrom.After(time.Now()) ||
		episode.AvailableTo.Before(time.Now())) {
		return merry.Wrap(errEpisodeNotPublished)
	}

	if len(lo.Intersect(u.Roles, episode.Usergroups)) == 0 {
		return merry.Wrap(errEpisodeNoAccess)
	}

	return nil
}
