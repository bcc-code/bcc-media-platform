package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"net/url"
	"strconv"
	"time"

	merry "github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/achievements"
	"github.com/bcc-code/brunstadtv/backend/applications"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/email"
	"github.com/bcc-code/brunstadtv/backend/export"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/memorycache"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwt"
	"github.com/samber/lo"
	null "gopkg.in/guregu/null.v4"
)

// SetDevicePushToken is the resolver for the setDevicePushToken field.
func (r *mutationRootResolver) SetDevicePushToken(ctx context.Context, token string, languages []string) (*model.Device, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	profile := user.GetProfileFromCtx(ginCtx)
	if profile == nil {
		return nil, merry.New(
			"profile is null",
			merry.WithUserMessage("device must be connected to a profile, which is not supported by anonymous accounts"),
		)
	}

	for i := 0; i < len(languages); i++ {
		if len(languages[i]) != 2 {
			return nil, merry.New("invalid language", merry.WithUserMessage("Probably invalid language code"))
		}
		if i > 4 {
			return nil, merry.New("too many languages", merry.WithUserMessage("Language array too large. Max 5 entries"))
		}
	}

	d := common.Device{
		Token:     token,
		ProfileID: profile.ID,
		Name:      "default",
		UpdatedAt: time.Now(),
		Languages: languages,
	}

	if !user.IsImpersonating(ginCtx) {
		err = r.Queries.SaveDevice(ginCtx, d)
		if err != nil {
			return nil, err
		}
	}
	return &model.Device{
		Token:     d.Token,
		UpdatedAt: d.UpdatedAt.Format(time.RFC3339),
	}, nil
}

// SetEpisodeProgress is the resolver for the episodeProgress field.
func (r *mutationRootResolver) SetEpisodeProgress(ctx context.Context, id string, progress *int, duration *int, context *model.EpisodeContext) (*model.Episode, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	p := user.GetProfileFromCtx(ginCtx)
	if p == nil {
		return nil, ErrProfileNotSet
	}
	e, err := r.QueryRoot().Episode(ctx, id, nil)
	if err != nil {
		return nil, err
	}
	episodeID := utils.AsInt(e.ID)
	q := r.Queries.ProfileQueries(p.ID)
	var episodeProgress *common.Progress
	pl := r.ProfileLoaders(ctx).ProgressLoader
	if progress == nil {
		if !user.IsImpersonating(ginCtx) {
			err = q.ClearProgress(ctx, episodeID)
		}
	} else {
		episodeProgress, err = pl.Get(ctx, utils.AsInt(e.ID))
		if err != nil {
			return nil, err
		}
		if episodeProgress == nil {
			var showID null.Int
			if e.Season != nil {
				s, err := r.QueryRoot().Season(ctx, e.Season.ID)
				if err != nil {
					return nil, err
				}
				showID.SetValid(int64(utils.AsInt(s.Show.ID)))
			}
			episodeProgress = &common.Progress{
				EpisodeID: episodeID,
				ShowID:    showID,
				Duration:  e.Duration,
				UpdatedAt: time.Now(),
			}
		}
		if duration != nil {
			episodeProgress.Duration = *duration
		}
		episodeProgress.Progress = *progress

		if context != nil {
			var col null.Int
			if context.CollectionID != nil {
				col.SetValid(int64(utils.AsInt(*context.CollectionID)))
			}
			episodeProgress.Context.CollectionID = col
		} else {
			episodeProgress.Context = common.EpisodeContext{}
		}

		if episodeProgress.Duration > 0 && float64(episodeProgress.Progress)/float64(episodeProgress.Duration) > 0.8 {
			if !episodeProgress.WatchedAt.Valid || episodeProgress.WatchedAt.Time.After(time.Now().Add(time.Hour*-12)) {
				episodeProgress.Watched++
				episodeProgress.WatchedAt = null.TimeFrom(time.Now())
			}
		}

		if !user.IsImpersonating(ginCtx) {
			err = q.SaveProgress(ctx, *episodeProgress)
		}
	}
	pl.Clear(ctx, episodeID)
	pl.Prime(ctx, episodeID, episodeProgress)
	r.Loaders.EpisodeProgressLoader.Clear(ctx, p.ID)
	return e, err
}

// SendSupportEmail is the resolver for the sendSupportEmail field.
func (r *mutationRootResolver) SendSupportEmail(ctx context.Context, title string, content string, html string) (bool, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return false, err
	}
	u := user.GetFromCtx(ginCtx)

	if u.Anonymous {
		return false, merry.New("User cannot be anonymous")
	}

	if user.IsImpersonating(ginCtx) {
		return false, nil
	}

	err = r.EmailService.SendEmail(ctx, email.SendOptions{
		From: email.Recipient{
			Name:  u.DisplayName,
			Email: u.Email,
		},
		To: email.Recipient{
			Name:  "Support",
			Email: "support@brunstad.tv",
		},
		Title:       title,
		Content:     content,
		HTMLContent: html,
	})
	if err != nil {
		return false, err
	}
	return true, nil
}

// CompleteTask is the resolver for the completeTask field.
func (r *mutationRootResolver) CompleteTask(ctx context.Context, id string, selectedAlternatives []string) (bool, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return false, err
	}

	task, err := getTask(ctx, r.Resolver, id)
	if err != nil {
		return false, err
	}

	if task.CompetitionMode {
		storedIds, err := r.Loaders.CompletedAndLockedTasksLoader.Get(ctx, p.ID)
		if err != nil {
			return false, err
		}

		if lo.Contains(utils.PointerArrayToArray(storedIds), task.ID) {
			return false, common.ErrTaskAlreadyCompleted
		}
	}

	var selectedUUIDs []uuid.UUID
	if selectedAlternatives != nil {
		// Optional
		errs := []error{}
		lo.ForEach(selectedAlternatives, func(id string, _ int) {
			uu, err := uuid.Parse(id)
			if err != nil {
				errs = append(errs, err)
			} else {
				selectedUUIDs = append(selectedUUIDs, uu)
			}
		})

		if len(errs) > 0 {
			log.L.Warn().Errs("errors", errs).Msg("Could not parse some selected alternatives as UUID")
		}
	}

	ginCtx, _ := utils.GinCtx(ctx)

	if !user.IsImpersonating(ginCtx) {
		err = r.Queries.SetTaskCompleted(ctx, sqlc.SetTaskCompletedParams{
			ProfileID:            p.ID,
			TaskID:               task.ID,
			SelectedAlternatives: selectedUUIDs,
		})
		if err != nil {
			return false, err
		}
	}

	r.Loaders.CompletedTasksLoader.Clear(ctx, p.ID)
	r.Loaders.CompletedAndLockedTasksLoader.Clear(ctx, p.ID)
	r.Loaders.CompletedLessonsLoader.Clear(ctx, p.ID)

	err = achievements.CheckNewAchievements(ctx, r.Queries, r.Loaders, achievements.Action{
		Collection: achievements.CollectionLessons,
		Action:     achievements.ActionCompleted,
	})

	if err != nil {
		return true, err
	}
	return true, nil
}

// LockLessonAnswers is the resolver for the lockLessonAnswers field.
func (r *mutationRootResolver) LockLessonAnswers(ctx context.Context, id string) (bool, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return false, err
	}

	ginCtx, _ := utils.GinCtx(ctx)
	if !user.IsImpersonating(ginCtx) {
		err = r.Queries.SetAnswerLock(ctx, sqlc.SetAnswerLockParams{
			Locked:    true,
			ProfileID: p.ID,
			LessonID:  utils.AsUuid(id),
		})
	}

	r.Loaders.CompletedAndLockedTasksLoader.Clear(ctx, p.ID)

	return err == nil, err
}

// SendTaskMessage is the resolver for the sendTaskMessage field.
func (r *mutationRootResolver) SendTaskMessage(ctx context.Context, taskID string, message *string) (string, error) {
	_, err := getProfile(ctx)
	if err != nil {
		return "", err
	}
	task, err := getTask(ctx, r.Resolver, taskID)
	if err != nil {
		return "", err
	}
	return r.sendMessage(ctx, task.ID, message, nil)
}

// UpdateTaskMessage is the resolver for the updateTaskMessage field.
func (r *mutationRootResolver) UpdateTaskMessage(ctx context.Context, id string, message string) (string, error) {
	_, err := getProfile(ctx)
	if err != nil {
		return "", err
	}
	return r.updateMessage(ctx, id, &message, nil)
}

// SendEpisodeFeedback is the resolver for the sendEpisodeFeedback field.
func (r *mutationRootResolver) SendEpisodeFeedback(ctx context.Context, episodeID string, message *string, rating *int) (string, error) {
	_, err := getProfile(ctx)
	if err != nil {
		return "", err
	}
	episode, err := getEpisode(ctx, r.Resolver, episodeID)
	if err != nil {
		return "", err
	}
	return r.sendMessage(ctx, episode.UUID, message, map[string]any{"rating": rating})
}

// UpdateEpisodeFeedback is the resolver for the updateEpisodeFeedback field.
func (r *mutationRootResolver) UpdateEpisodeFeedback(ctx context.Context, id string, message *string, rating *int) (string, error) {
	_, err := getProfile(ctx)
	if err != nil {
		return "", err
	}
	return r.updateMessage(ctx, id, message, map[string]any{"rating": rating})
}

// ConfirmAchievement is the resolver for the confirmAchievement field.
func (r *mutationRootResolver) ConfirmAchievement(ctx context.Context, id string) (*model.ConfirmAchievementResult, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return nil, err
	}
	uid, err := uuid.Parse(id)
	if err != nil {
		return nil, err
	}
	ids, err := r.Loaders.UnconfirmedAchievementsLoader.Get(ctx, p.ID)
	if err != nil {
		return nil, err
	}
	if !lo.Contains(utils.PointerArrayToArray(ids), uid) {
		return nil, merry.New("", merry.WithUserMessage("Achievement is not unconfirmed"))
	}
	ids = lo.Filter(ids, func(i *uuid.UUID, _ int) bool {
		return i != nil && *i != uid
	})
	ginCtx, _ := utils.GinCtx(ctx)
	if !user.IsImpersonating(ginCtx) {
		err = r.Queries.ConfirmAchievement(ctx, sqlc.ConfirmAchievementParams{
			ProfileID:     p.ID,
			AchievementID: uid,
		})
		if err != nil {
			return nil, err
		}
	}
	r.Loaders.UnconfirmedAchievementsLoader.Clear(ctx, p.ID)
	return &model.ConfirmAchievementResult{
		Success: true,
	}, nil
}

// Application is the resolver for the application field.
func (r *queryRootResolver) Application(ctx context.Context) (*model.Application, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	app, err := applications.GetFromCtx(ginCtx)
	if err != nil {
		return nil, err
	}

	var page *model.Page
	if app.DefaultPageID.Valid {
		page = &model.Page{
			ID: strconv.Itoa(int(app.DefaultPageID.Int64)),
		}
	}
	var searchPage *model.Page
	if app.SearchPageID.Valid {
		searchPage = &model.Page{
			ID: strconv.Itoa(int(app.SearchPageID.Int64)),
		}
	}

	return &model.Application{
		ID:            strconv.Itoa(app.ID),
		Code:          app.Code,
		Page:          page,
		SearchPage:    searchPage,
		ClientVersion: app.ClientVersion,
	}, nil
}

// Export is the resolver for the export field.
func (r *queryRootResolver) Export(ctx context.Context, groups []string) (*model.Export, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	profile := user.GetProfileFromCtx(ginCtx)
	if profile == nil {
		return nil, merry.New(
			"Not authorized",
			merry.WithUserMessage("you are not authorized for this query"),
		)
	}

	url, err := export.DoExport(ctx, r, r.AWSConfig.GetTempStorageBucket())
	if err != nil {
		return nil, err
	}

	return &model.Export{
		URL:       url,
		DbVersion: export.SQLiteExportDBVersion,
	}, nil
}

// Redirect is the resolver for the redirect field.
func (r *queryRootResolver) Redirect(ctx context.Context, id string) (*model.RedirectLink, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	profile := user.GetProfileFromCtx(ginCtx)
	if profile == nil {
		return nil, merry.New(
			"Not authorized",
			merry.WithUserMessage("you are not authorized for this query"),
		)
	}

	redirID, err := r.Loaders.RedirectIDFromCodeLoader.Get(ctx, id)
	if err != nil {
		return nil, merry.Wrap(err, merry.WithUserMessage("Failed to retrieve data"))
	}

	if redirID == nil {
		return nil, merry.New("no rows", merry.WithUserMessage("Code not found"))
	}

	redir, err := r.Loaders.RedirectLoader.Get(ctx, *redirID)
	if err != nil {
		return nil, merry.Wrap(err, merry.WithUserMessage("Failed to retrieve data"))
	}

	// Build a JWT!
	tok, err := jwt.NewBuilder().
		Claim("person_id", profile.UserID).
		Issuer("https://api.brunstad.tv/").
		IssuedAt(time.Now()).
		Expiration(time.Now().Add(30 * time.Second)).
		Build()
	if err != nil {
		return nil, merry.Wrap(err, merry.WithUserMessage("Internal server error. TOKEN-ERROR"))
	}

	// Sign a JWT!
	signed, err := jwt.Sign(tok, jwt.WithKey(jwa.RS256, r.RedirectConfig.GetPrivateKey()))
	if err != nil {
		return nil, merry.Wrap(err, merry.WithUserMessage("Internal server error. TOKEN-SIGN-ERROR"))
	}

	// Add JWT to url
	url, err := url.Parse(redir.TargetURL)
	if err != nil {
		return nil, merry.Wrap(err, merry.WithUserMessage("Internal server error. URL-PARSE"))
	}
	q := url.Query()
	q.Add("token", string(signed))
	url.RawQuery = q.Encode()

	return &model.RedirectLink{
		URL: url.String(),
	}, nil
}

// Page is the resolver for the page field.
func (r *queryRootResolver) Page(ctx context.Context, id *string, code *string) (*model.Page, error) {
	if id != nil {
		return resolverForIntID(ctx, &itemLoaders[int, common.Page]{
			Item:        r.Loaders.PageLoader,
			Permissions: r.Loaders.PagePermissionLoader,
		}, *id, model.PageFrom)
	}
	if code != nil {
		intID, err := r.Loaders.PageIDFromCodeLoader.Get(ctx, *code)
		if err != nil {
			return nil, err
		}
		if intID == nil {
			return nil, merry.Sentinel("No page found with that code")
		}
		return resolverFor(ctx, &itemLoaders[int, common.Page]{
			Item:        r.Loaders.PageLoader,
			Permissions: r.Loaders.PagePermissionLoader,
		}, *intID, model.PageFrom)
	}
	return nil, merry.Sentinel("Must specify either ID or code", merry.WithHTTPCode(400))
}

// Section is the resolver for the section field.
func (r *queryRootResolver) Section(ctx context.Context, id string, timestamp *string) (model.Section, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Section]{
		Item:        r.Loaders.SectionLoader,
		Permissions: r.Loaders.SectionPermissionLoader,
	}, id, model.SectionFrom)
}

// Show is the resolver for the show field.
func (r *queryRootResolver) Show(ctx context.Context, id string) (*model.Show, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Show]{
		Item:        r.Loaders.ShowLoader,
		Permissions: r.Loaders.ShowPermissionLoader,
	}, id, model.ShowFrom)
}

// Season is the resolver for the season field.
func (r *queryRootResolver) Season(ctx context.Context, id string) (*model.Season, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Season]{
		Item:        r.Loaders.SeasonLoader,
		Permissions: r.Loaders.SeasonPermissionLoader,
	}, id, model.SeasonFrom)
}

// Episode is the resolver for the episode field.
func (r *queryRootResolver) Episode(ctx context.Context, id string, context *model.EpisodeContext) (*model.Episode, error) {
	ginCtx, _ := utils.GinCtx(ctx)
	if context != nil {
		eCtx := common.EpisodeContext{
			CollectionID: utils.AsNullInt(context.CollectionID),
		}
		ginCtx.Set(episodeContextKey, eCtx)
	}
	if intID, err := strconv.ParseInt(id, 10, 64); err == nil {
		e, err := r.GetLoaders().EpisodeLoader.Get(ctx, int(intID))
		if err != nil {
			return nil, err
		}
		u := user.GetFromCtx(ginCtx)
		if e.Unlisted && u.Anonymous {
			return nil, ErrItemNotFound
		}
	} else {
		uuidValue, err := uuid.Parse(id)
		if err != nil {
			return nil, ErrItemNotFound
		}
		eid, err := r.GetLoaders().EpisodeIDFromUuidLoader.Get(ctx, uuidValue)
		if err != nil {
			return nil, err
		}
		if eid == nil {
			return nil, ErrItemNotFound
		}
		id = fmt.Sprint(*eid)
	}
	return resolverForIntID(ctx, &itemLoaders[int, common.Episode]{
		Item:        r.Loaders.EpisodeLoader,
		Permissions: r.Loaders.EpisodePermissionLoader,
	}, id, model.EpisodeFrom)
}

// Collection is the resolver for the collection field.
func (r *queryRootResolver) Collection(ctx context.Context, id *string, slug *string) (*model.Collection, error) {
	var key string
	if slug != nil {
		intID, err := r.Loaders.CollectionIDFromSlugLoader.Get(ctx, *slug)
		if err != nil {
			return nil, err
		}
		if intID == nil {
			return nil, merry.New("code invalid", merry.WithUserMessage("Invalid slug specified"))
		}
		key = strconv.Itoa(*intID)
	} else if id != nil {
		key = *id
	} else {
		return nil, merry.New("No options specified", merry.WithUserMessage("Specify either ID or slug"))
	}
	return resolverForIntID(ctx, &itemLoaders[int, common.Collection]{
		Item: r.Loaders.CollectionLoader,
	}, key, model.CollectionFrom)
}

// Search is the resolver for the search field.
func (r *queryRootResolver) Search(ctx context.Context, queryString string, first *int, offset *int, typeArg *string, minScore *int) (*model.SearchResult, error) {
	return searchResolver(r, ctx, queryString, first, offset, typeArg, minScore)
}

// PendingAchievements is the resolver for the pendingAchievements field.
func (r *queryRootResolver) PendingAchievements(ctx context.Context) ([]*model.Achievement, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return nil, err
	}
	err = achievements.CheckAllAchievements(ctx, r.Queries, r.Loaders)
	if err != nil {
		return nil, err
	}
	ids, err := r.Loaders.UnconfirmedAchievementsLoader.Get(ctx, p.ID)
	if err != nil {
		return nil, err
	}
	items, err := r.Loaders.AchievementLoader.GetMany(ctx, utils.PointerArrayToArray(ids))
	if err != nil {
		return nil, err
	}
	return utils.MapWithCtx(ctx, items, model.AchievementFrom), nil
}

// Achievement is the resolver for the achievement field.
func (r *queryRootResolver) Achievement(ctx context.Context, id string) (*model.Achievement, error) {
	uid, err := uuid.Parse(id)
	if err != nil {
		return nil, err
	}
	achievement, err := r.Loaders.AchievementLoader.Get(ctx, uid)
	if err != nil {
		return nil, err
	}
	if achievement == nil {
		return nil, common.ErrItemNotFound
	}
	return model.AchievementFrom(ctx, achievement), nil
}

// AchievementGroup is the resolver for the achievementGroup field.
func (r *queryRootResolver) AchievementGroup(ctx context.Context, id string) (*model.AchievementGroup, error) {
	uid, err := uuid.Parse(id)
	if err != nil {
		return nil, err
	}
	group, err := r.Loaders.AchievementGroupLoader.Get(ctx, uid)
	if err != nil {
		return nil, err
	}
	if group == nil {
		return nil, common.ErrItemNotFound
	}
	return model.AchievementGroupFrom(ctx, group), nil
}

// AchievementGroups is the resolver for the achievementGroups field.
func (r *queryRootResolver) AchievementGroups(ctx context.Context, first *int, offset *int) (*model.AchievementGroupPagination, error) {
	ids, err := memorycache.GetOrSet(ctx, "achievement_groups", r.Queries.ListAchievementGroups)
	if err != nil {
		return nil, err
	}
	if ids == nil {
		ids = &[]uuid.UUID{}
	}
	page := utils.Paginate(*ids, first, offset, nil)

	groups, err := r.Loaders.AchievementGroupLoader.GetMany(ctx, page.Items)
	if err != nil {
		return nil, err
	}

	return &model.AchievementGroupPagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  utils.MapWithCtx(ctx, groups, model.AchievementGroupFrom),
	}, nil
}

// StudyTopic is the resolver for the studyTopic field.
func (r *queryRootResolver) StudyTopic(ctx context.Context, id string) (*model.StudyTopic, error) {
	_, err := getProfile(ctx)
	if err != nil {
		return nil, err
	}
	uid, err := uuid.Parse(id)
	if err != nil {
		return nil, err
	}
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	return resolverFor(ctx, &itemLoaders[uuid.UUID, common.StudyTopic]{
		Item: r.Loaders.StudyTopicLoader,
	}, uid, func(ctx context.Context, topic *common.StudyTopic) *model.StudyTopic {
		return &model.StudyTopic{
			ID:    topic.ID.String(),
			Title: topic.Title.Get(languages),
		}
	})
}

// StudyLesson is the resolver for the studyLesson field.
func (r *queryRootResolver) StudyLesson(ctx context.Context, id string) (*model.Lesson, error) {
	_, err := getProfile(ctx)
	if err != nil {
		return nil, err
	}
	uid, err := uuid.Parse(id)
	if err != nil {
		return nil, err
	}
	lesson, err := r.Loaders.StudyLessonLoader.Get(ctx, uid)
	if err != nil {
		return nil, err
	}
	if lesson == nil {
		return nil, ErrItemNotFound
	}
	return model.LessonFrom(ctx, lesson), nil
}

// Calendar is the resolver for the calendar field.
func (r *queryRootResolver) Calendar(ctx context.Context) (*model.Calendar, error) {
	return &model.Calendar{}, nil
}

// Event is the resolver for the event field.
func (r *queryRootResolver) Event(ctx context.Context, id string) (*model.Event, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Event]{
		Item: r.Loaders.EventLoader,
	}, id, model.EventFrom)
}

// Faq is the resolver for the faq field.
func (r *queryRootResolver) Faq(ctx context.Context) (*model.Faq, error) {
	return &model.Faq{}, nil
}

// Me is the resolver for the me field.
func (r *queryRootResolver) Me(ctx context.Context) (*model.User, error) {
	gc, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	usr := user.GetFromCtx(gc)

	u := &model.User{
		Anonymous: usr.IsAnonymous(),
		BccMember: usr.IsActiveBCC(),
		Roles:     usr.Roles,
		Analytics: &model.Analytics{},
	}

	if pid := gc.GetString(auth0.CtxUserID); pid != "" {
		u.ID = &pid
	}

	//if aud := gc.GetString(auth0.CtxAudience); aud != "" {
	//	u.Audience = &aud
	//}

	if usr.Email != "" {
		u.Email = &usr.Email
	}

	return u, nil
}

// Config is the resolver for the config field.
func (r *queryRootResolver) Config(ctx context.Context) (*model.Config, error) {
	return &model.Config{}, nil
}

// Profiles is the resolver for the profiles field.
func (r *queryRootResolver) Profiles(ctx context.Context) ([]*model.Profile, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	profiles := user.GetProfilesFromCtx(ginCtx)

	return lo.Map(profiles, func(i common.Profile, _ int) *model.Profile {
		return &model.Profile{
			ID:   i.ID.String(),
			Name: i.Name,
		}
	}), nil
}

// Profile is the resolver for the profile field.
func (r *queryRootResolver) Profile(ctx context.Context) (*model.Profile, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	profile := user.GetProfileFromCtx(ginCtx)

	return &model.Profile{
		ID:   profile.ID.String(),
		Name: profile.Name,
	}, nil
}

// LegacyIDLookup is the resolver for the legacyIDLookup field.
func (r *queryRootResolver) LegacyIDLookup(ctx context.Context, options *model.LegacyIDLookupOptions) (*model.LegacyIDLookup, error) {
	var id *int
	var err error
	if options.EpisodeID != nil {
		id, err = r.Loaders.EpisodeIDFromLegacyIDLoader.Get(ctx, *options.EpisodeID)
	}
	if options.ProgramID != nil {
		id, err = r.Loaders.EpisodeIDFromLegacyProgramIDLoader.Get(ctx, *options.ProgramID)
	}
	if err != nil {
		return nil, err
	}
	if id == nil {
		return nil, ErrItemNotFound
	}
	return &model.LegacyIDLookup{
		ID: strconv.Itoa(*id),
	}, nil
}

// MutationRoot returns generated.MutationRootResolver implementation.
func (r *Resolver) MutationRoot() generated.MutationRootResolver { return &mutationRootResolver{r} }

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

type mutationRootResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
