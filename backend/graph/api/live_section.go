package graph

import (
	"context"
	"strconv"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

const liveSectionCacheTTL = 2 * time.Minute

func (r *Resolver) liveSectionEntry(ctx context.Context) (*common.CalendarEntry, error) {
	if r.LiveApp.BaseURL == "" {
		return nil, nil
	}
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	if u := user.GetFromCtx(ginCtx); u == nil || !u.IsActiveBCC() {
		return nil, nil
	}

	conf, err := withCacheAndTimestamp(ctx, "global_config", r.Queries.GetGlobalConfig, time.Second*30, nil)
	if err != nil {
		return nil, err
	}
	if !conf.LiveOnline {
		return nil, nil
	}

	current, err := memorycache.GetOrSet(ctx, "live_section:current", func(ctx context.Context) (*common.CalendarEntry, error) {
		return r.Queries.GetCurrentMeetingEntry(ctx)
	}, cache.WithExpiration(liveSectionCacheTTL))
	if err != nil {
		return nil, err
	}
	// The cached entry may have ended since it was fetched.
	if current == nil || !time.Now().Before(current.End) {
		return nil, nil
	}

	// Same gate as Episode.overrideUrl.
	window, err := r.bufferWindowForEntry(ctx, strconv.Itoa(current.ID))
	if err != nil || window == nil {
		return nil, err
	}
	return window.entry, nil
}
