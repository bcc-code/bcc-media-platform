package graph

import (
	"context"
	"strconv"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// liveBannerCacheTTL is how long the meeting on air is cached. Banner sections
// are requested on every page load, and a meeting showing up or ending this
// much late is not noticeable.
const liveBannerCacheTTL = 30 * time.Second

// banner returns the content of a banner section from its source, or nil when
// the source has nothing to show right now.
func (r *Resolver) banner(ctx context.Context, source model.BannerSource) (*model.Banner, error) {
	switch source {
	case model.BannerSourceLive:
		return r.liveBanner(ctx)
	}
	return nil, nil
}

// liveBanner links active BCC members to the Live app while a meeting is on air,
// the stream is online and the meeting's live buffer is open to them. Nil otherwise.
func (r *Resolver) liveBanner(ctx context.Context) (*model.Banner, error) {
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

	current, err := memorycache.GetOrSet(ctx, "live_banner:current", func(ctx context.Context) (*common.CalendarEntry, error) {
		return r.Queries.GetCurrentMeetingEntry(ctx)
	}, cache.WithExpiration(liveBannerCacheTTL))
	if err != nil {
		return nil, err
	}
	// The cached entry may have ended since it was fetched.
	if current == nil || !time.Now().Before(current.End) {
		return nil, nil
	}

	// Load the entry as the user sees it, for its translated title.
	entry, err := r.GetFilteredLoaders(ctx).CalendarEntryLoader.Get(ctx, current.ID)
	if err != nil {
		return nil, err
	}
	if entry == nil {
		return nil, nil
	}
	// Same gate as Episode.overrideUrl, so the banner and the episode redirect agree.
	window, err := r.bufferWindowForEntry(ctx, strconv.Itoa(entry.ID))
	if err != nil || window == nil {
		return nil, err
	}
	return &model.Banner{
		Title: entry.Title.Get(user.GetLanguagesFromCtx(ginCtx)),
		URL:   r.LiveApp.RootURL(),
	}, nil
}
