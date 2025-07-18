package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.
// Code generated by github.com/99designs/gqlgen version v0.17.74

import (
	"context"
	"strconv"
	"time"

	merry "github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/achievements"
	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/email"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/generated"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/ratelimit"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
	null "gopkg.in/guregu/null.v4"
)

// Collection is the resolver for the collection field.
func (r *addToCollectionResultResolver) Collection(ctx context.Context, obj *model.AddToCollectionResult) (*model.UserCollection, error) {
	return r.QueryRoot().UserCollection(ctx, obj.Collection.ID)
}

// SetDevicePushToken is the resolver for the setDevicePushToken field.
func (r *mutationRootResolver) SetDevicePushToken(ctx context.Context, token string, languages []string) (*model.Device, error) {
	// For backwards compatibility
	return r.SetDevicePushTokenV2(ctx, token, languages, model.OsUnknown, 0)
}

// SetDevicePushTokenV2 is the resolver for the setDevicePushTokenV2 field.
func (r *mutationRootResolver) SetDevicePushTokenV2(ctx context.Context, token string, languages []string, os model.Os, appBuildNumber int) (*model.Device, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	app, err := common.GetApplicationFromCtx(ginCtx)
	if err != nil {
		return nil, err
	}

	profile := user.GetProfileFromCtx(ginCtx)
	profileID := uuid.NullUUID{}

	if profile != nil {
		profileID = uuid.NullUUID{
			UUID:  profile.ID,
			Valid: true,
		}
	}

	for i := 0; i < len(languages); i++ {
		if len(languages[i]) > 3 {
			return nil, merry.New("invalid language", merry.WithUserMessage("Probably invalid language code"))
		}
		if i > 4 {
			return nil, merry.New("too many languages", merry.WithUserMessage("Language array too large. Max 5 entries"))
		}
	}

	d := common.Device{
		Token:              token,
		ProfileID:          profileID,
		Name:               "default",
		UpdatedAt:          time.Now(),
		Languages:          languages,
		ApplicationGroupID: app.GroupID,
		Os:                 null.StringFrom(os.String()),
		AppBuildNumber:     int32(appBuildNumber),
	}

	err = r.Queries.SaveDevice(ginCtx, d)
	if err != nil {
		return nil, err
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
		err = q.ClearProgress(ctx, episodeID)
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

		err = q.SaveProgress(ctx, *episodeProgress)
	}
	pl.Clear(ctx, episodeID)
	pl.Prime(ctx, episodeID, episodeProgress)
	ids, err := r.Loaders.EpisodeProgressLoader.Get(ctx, p.ID)
	if err != nil {
		return nil, err
	}
	found := false
	for _, i := range ids {
		if i != nil && *i == episodeID {
			found = true
			break
		}
	}
	if !found && episodeProgress != nil {
		ids = append(ids, &episodeID)
		r.Loaders.EpisodeProgressLoader.Clear(ctx, p.ID)
		r.Loaders.EpisodeProgressLoader.Prime(ctx, p.ID, ids)
	} else if found && episodeProgress == nil {
		ids = lo.Filter(ids, func(i *int, _ int) bool {
			return i != nil && *i != episodeID
		})
		r.Loaders.EpisodeProgressLoader.Clear(ctx, p.ID)
		r.Loaders.EpisodeProgressLoader.Prime(ctx, p.ID, ids)
	}
	return e, err
}

// SetShortProgress is the resolver for the setShortProgress field.
func (r *mutationRootResolver) SetShortProgress(ctx context.Context, id string, progress *float64, duration *float64) (*model.Short, error) {
	s, err := r.QueryRoot().Short(ctx, id)
	if err != nil {
		return nil, err
	}
	short, err := r.GetLoaders().ShortLoader.Get(ctx, utils.AsUuid(s.ID))
	if err != nil {
		return nil, err
	}
	_, err = r.storeMediaProgress(ctx, short.MediaID, shortsWatchedThreshold, progress, duration)
	if err != nil {
		return nil, err
	}
	return s, nil
}

// SendSupportEmail is the resolver for the sendSupportEmail field.
func (r *mutationRootResolver) SendSupportEmail(ctx context.Context, title string, content string, html string, options *model.EmailOptions) (bool, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return false, err
	}
	u := user.GetFromCtx(ginCtx)

	err = ratelimit.Endpoint(ctx, "support-email", 2, true)
	if err != nil {
		return false, err
	}

	var e string
	var n string
	if options != nil {
		e = options.Email
		n = options.Name
	} else if u.Anonymous {
		e = "anonymous@brunstad.tv"
		n = "Anonymous User"
	} else {
		e = u.Email
		n = u.DisplayName
	}

	app, err := common.GetApplicationFromCtx(ginCtx)
	if err != nil {
		return false, err
	}

	var supportEmail string
	if app.SupportEmail.Valid {
		supportEmail = app.SupportEmail.String
	} else {
		supportEmail = "support@brunstad.tv"
	}

	err = r.EmailService.SendEmail(ctx, email.SendOptions{
		From: email.Recipient{
			Name:  n,
			Email: e,
		},
		To: email.Recipient{
			Name:  "Support",
			Email: supportEmail,
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

	completedIDs, err := r.Loaders.CompletedTasksLoader.Get(ctx, p.ID)
	completed := lo.SomeBy(completedIDs, func(id *uuid.UUID) bool {
		return id != nil && *id == task.ID
	})

	err = r.Queries.SetTaskCompleted(ctx, sqlc.SetTaskCompletedParams{
		ProfileID:            p.ID,
		TaskID:               task.ID,
		SelectedAlternatives: selectedUUIDs,
	})
	if err != nil {
		return false, err
	}

	if task.QuestionType == common.QuestionTaskTypeAlternatives &&
		(task.MultiSelect.Valid || !task.MultiSelect.Bool) &&
		len(selectedUUIDs) > 0 {
		correct, err := r.Queries.IsAnswerCorrect(ctx, selectedUUIDs[0])
		if err != nil {
			return false, err
		}

		gCtx, err := utils.GinCtx(ctx)
		if err != nil {
			return false, err
		}

		personID := user.GetFromCtx(gCtx).PersonID

		log.L.Debug().
			Str("taskID", task.ID.String()).
			Str("answerID", selectedUUIDs[0].String()).
			Bool("correct", correct).
			Msg("Submitting answer to BMM")
		err = r.BMMClient.SubmitAnswer(task.ID.String(), correct, selectedUUIDs[0].String(), personID)

		if err != nil {
			log.L.Error().Err(err).Msg("Error submitting answer to BMM")
			// Log and continue, we shoudn't block the user here
		}
	}

	if !completed {
		// Check study specific achievements
		actions := []achievements.Action{
			{
				Collection: achievements.CollectionTopics,
				Action:     achievements.ActionCompletedItems,
			},
			{
				Collection: achievements.CollectionLessons,
				Action:     achievements.ActionCompleted,
			},
			{
				Collection: achievements.CollectionTasks,
				Action:     achievements.ActionCompleted,
			},
		}

		for _, a := range actions {
			err = achievements.CheckNewAchievements(ctx, r.Queries, r.Loaders, a)
			if err != nil {
				log.L.Error().Err(err).Send()
				return false, err
			}
		}
	}

	r.Loaders.CompletedTasksLoader.Clear(ctx, p.ID)
	r.Loaders.CompletedAndLockedTasksLoader.Clear(ctx, p.ID)
	r.Loaders.CompletedLessonsLoader.Clear(ctx, p.ID)
	r.ProfileLoaders(ctx).TaskCompletedLoader.ClearAll()
	r.ProfileLoaders(ctx).TaskAlternativesAnswersCountLoader.ClearAll()

	return true, nil
}

// LockLessonAnswers is the resolver for the lockLessonAnswers field.
func (r *mutationRootResolver) LockLessonAnswers(ctx context.Context, id string) (bool, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return false, err
	}

	err = r.Queries.SetAnswerLock(ctx, sqlc.SetAnswerLockParams{
		Locked:    true,
		ProfileID: p.ID,
		LessonID:  utils.AsUuid(id),
	})

	r.Loaders.CompletedAndLockedTasksLoader.Clear(ctx, p.ID)
	r.Loaders.StudyTaskLoader.ClearAll()
	r.ProfileLoaders(ctx).TaskCompletedLoader.ClearAll()
	r.ProfileLoaders(ctx).TaskAlternativesAnswersCountLoader.ClearAll()

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
	err = r.Queries.ConfirmAchievement(ctx, sqlc.ConfirmAchievementParams{
		ProfileID:     p.ID,
		AchievementID: uid,
	})
	if err != nil {
		return nil, err
	}
	r.Loaders.UnconfirmedAchievementsLoader.Clear(ctx, p.ID)
	return &model.ConfirmAchievementResult{
		Success: true,
	}, nil
}

// AnswerSurveyQuestion is the resolver for the answerSurveyQuestion field.
func (r *mutationRootResolver) AnswerSurveyQuestion(ctx context.Context, id string, answer string) (*model.AnswerSurveyQuestionResult, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return nil, err
	}
	uid, err := uuid.Parse(id)
	if err != nil {
		return nil, common.ErrInvalidUUID
	}
	q, err := r.Loaders.SurveyQuestionLoader.Get(ctx, uid)
	if err != nil {
		return nil, err
	}
	if q == nil {
		return nil, common.ErrItemNotFound
	}
	err = r.Queries.UpsertSurveyAnswer(ctx, sqlc.UpsertSurveyAnswerParams{
		ProfileID:  p.ID,
		QuestionID: uid,
	})
	if err != nil {
		return nil, err
	}
	key, err := r.sendMessage(ctx, uid, &answer, nil)
	if err != nil {
		return nil, err
	}
	return &model.AnswerSurveyQuestionResult{
		ID: key,
	}, nil
}

// UpdateSurveyQuestionAnswer is the resolver for the updateSurveyQuestionAnswer field.
func (r *mutationRootResolver) UpdateSurveyQuestionAnswer(ctx context.Context, key string, answer string) (*model.AnswerSurveyQuestionResult, error) {
	_, err := getProfile(ctx)
	if err != nil {
		return nil, err
	}
	key, err = r.updateMessage(ctx, key, &answer, nil)
	if err != nil {
		return nil, err
	}
	return &model.AnswerSurveyQuestionResult{
		ID: key,
	}, nil
}

// AddEpisodeToMyList is the resolver for the addEpisodeToMyList field.
func (r *mutationRootResolver) AddEpisodeToMyList(ctx context.Context, episodeID string) (*model.AddToCollectionResult, error) {
	e, err := r.addItemToCollection(ctx, "episode", episodeID)
	if err != nil {
		return nil, err
	}
	return &model.AddToCollectionResult{
		Collection: &model.UserCollection{
			ID: e.CollectionID.String(),
		},
		EntryID: e.ID.String(),
	}, nil
}

// AddShowToMyList is the resolver for the addShowToMyList field.
func (r *mutationRootResolver) AddShowToMyList(ctx context.Context, showID string) (*model.AddToCollectionResult, error) {
	e, err := r.addItemToCollection(ctx, "show", showID)
	if err != nil {
		return nil, err
	}
	return &model.AddToCollectionResult{
		Collection: &model.UserCollection{
			ID: e.CollectionID.String(),
		},
		EntryID: e.ID.String(),
	}, nil
}

// AddShortToMyList is the resolver for the addShortToMyList field.
func (r *mutationRootResolver) AddShortToMyList(ctx context.Context, shortID string) (*model.AddToCollectionResult, error) {
	e, err := r.addItemToCollection(ctx, "short", shortID)
	if err != nil {
		return nil, err
	}
	return &model.AddToCollectionResult{
		Collection: &model.UserCollection{
			ID: e.CollectionID.String(),
		},
		EntryID: e.ID.String(),
	}, nil
}

// RemoveEntryFromMyList is the resolver for the removeEntryFromMyList field.
func (r *mutationRootResolver) RemoveEntryFromMyList(ctx context.Context, entryID string) (*model.UserCollection, error) {
	myList, err := r.QueryRoot().MyList(ctx)
	if err != nil {
		return nil, err
	}
	uid, err := uuid.Parse(entryID)
	if err != nil {
		return nil, err
	}
	listID := utils.AsUuid(myList.ID)
	pointerEntryIDs, err := r.Loaders.UserCollectionEntryIDsLoader.Get(ctx, listID)
	if err != nil {
		return nil, err
	}

	entryIDs := utils.PointerArrayToArray(pointerEntryIDs)
	if !lo.Contains(entryIDs, uid) {
		chunks := lo.Chunk(entryIDs, 20)
		for _, chunk := range chunks {
			entries, err := r.Loaders.UserCollectionEntryLoader.GetMany(ctx, chunk)
			if err != nil {
				return nil, err
			}
			for _, entry := range entries {
				if entry.ItemID == uid {
					uid = entry.ID
					break
				}
			}
		}
	}
	// Make sure the entry is found
	if !lo.Contains(entryIDs, uid) {
		return nil, common.ErrItemNotFound
	}

	pointerEntryIDs = lo.Filter(pointerEntryIDs, func(i *uuid.UUID, _ int) bool {
		return *i != uid
	})
	err = r.Queries.DeleteUserCollectionEntry(ctx, uid)
	if err != nil {
		return nil, err
	}
	r.Loaders.UserCollectionEntryIDsLoader.Clear(ctx, listID)
	r.Loaders.UserCollectionEntryIDsLoader.Prime(ctx, listID, pointerEntryIDs)
	return r.QueryRoot().MyList(ctx)
}

// UpdateUserMetadata is the resolver for the updateUserMetadata field.
func (r *mutationRootResolver) UpdateUserMetadata(ctx context.Context, birthData model.BirthOptions, nameData model.NameOptions) (bool, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return false, err
	}
	u := user.GetFromCtx(ginCtx)
	if u.IsRegistered() && !u.IsActiveBCC() {
		displayName := nameData.First + " " + nameData.Last
		_, err = r.AuthClient.UpdateUser(ctx, ginCtx.GetString(auth0.CtxUserID), auth0.UserInfo{
			GivenName:  nameData.First,
			FamilyName: nameData.Last,
			Name:       displayName,
			Nickname:   nameData.First,
		}, auth0.UserMetadata{
			BirthYear:       strconv.Itoa(birthData.Year),
			MediaSubscriber: "true",
		})
		return err == nil, err
	}
	return false, nil
}

// SendVerificationEmail is the resolver for the sendVerificationEmail field.
func (r *mutationRootResolver) SendVerificationEmail(ctx context.Context) (bool, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return false, err
	}
	u := user.GetFromCtx(ginCtx)
	if u.Anonymous {
		return false, merry.New("user is anonymous", merry.WithUserMessage("Cannot be unauthenticated for this request"))
	}
	if u.EmailVerified {
		return false, merry.New("email already verified", merry.WithUserMessage("Email already verified"))
	}
	err = ratelimit.Endpoint(ctx, "verify-email", 3, false)
	if err != nil {
		return false, err
	}
	err = r.AuthClient.SendVerificationEmail(ctx, ginCtx.GetString(auth0.CtxUserID))
	return true, err
}

// Subscribe is the resolver for the subscribe field.
func (r *mutationRootResolver) Subscribe(ctx context.Context, topic model.SubscriptionTopic) (bool, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return false, err
	}
	if !topic.IsValid() {
		return false, nil
	}
	err = ratelimit.Endpoint(ctx, "subscribe:"+topic.String(), 5, false)
	if err != nil {
		return false, err
	}
	err = r.GetQueries().AddSubscription(ctx, sqlc.AddSubscriptionParams{
		Key:       topic.String(),
		ProfileID: p.ID,
	})
	if err != nil {
		return false, err
	}
	return true, nil
}

// Unsubscribe is the resolver for the unsubscribe field.
func (r *mutationRootResolver) Unsubscribe(ctx context.Context, topic model.SubscriptionTopic) (bool, error) {
	p, err := getProfile(ctx)
	if err != nil {
		return false, err
	}
	if !topic.IsValid() {
		return false, nil
	}
	err = ratelimit.Endpoint(ctx, "unsubscribe:"+topic.String(), 5, false)
	if err != nil {
		return false, err
	}
	err = r.GetQueries().RemoveSubscription(ctx, sqlc.RemoveSubscriptionParams{
		Key:       topic.String(),
		ProfileID: p.ID,
	})
	if err != nil {
		return false, err
	}
	return true, nil
}

// AddToCollectionResult returns generated.AddToCollectionResultResolver implementation.
func (r *Resolver) AddToCollectionResult() generated.AddToCollectionResultResolver {
	return &addToCollectionResultResolver{r}
}

// MutationRoot returns generated.MutationRootResolver implementation.
func (r *Resolver) MutationRoot() generated.MutationRootResolver { return &mutationRootResolver{r} }

type addToCollectionResultResolver struct{ *Resolver }
type mutationRootResolver struct{ *Resolver }
