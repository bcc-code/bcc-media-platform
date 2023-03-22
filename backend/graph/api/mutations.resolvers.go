package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"time"

	merry "github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/achievements"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/email"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/ratelimit"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
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
	if !found {
		ids = append(ids, &episodeID)
		r.Loaders.EpisodeProgressLoader.Prime(ctx, p.ID, ids)
	}
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

	err = r.Queries.SetTaskCompleted(ctx, sqlc.SetTaskCompletedParams{
		ProfileID:            p.ID,
		TaskID:               task.ID,
		SelectedAlternatives: selectedUUIDs,
	})
	if err != nil {
		return false, err
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

	err = r.Queries.SetAnswerLock(ctx, sqlc.SetAnswerLockParams{
		Locked:    true,
		ProfileID: p.ID,
		LessonID:  utils.AsUuid(id),
	})

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
			Nickname:   displayName,
			UserMetadata: auth0.UserMetadata{
				BirthMonth:      birthData.Month,
				BirthYear:       birthData.Year,
				MediaSubscriber: true,
			},
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
	if u.EmailVerified {
		return false, merry.New("email already verified", merry.WithUserMessage("Email already verified"))
	}
	err = ratelimit.Endpoint(ctx, "verify-email", 1, false)
	if err != nil {
		return false, err
	}
	err = r.AuthClient.SendVerificationEmail(ctx, ginCtx.GetString(auth0.CtxUserID))
	return true, err
}

// AddToCollectionResult returns generated.AddToCollectionResultResolver implementation.
func (r *Resolver) AddToCollectionResult() generated.AddToCollectionResultResolver {
	return &addToCollectionResultResolver{r}
}

// MutationRoot returns generated.MutationRootResolver implementation.
func (r *Resolver) MutationRoot() generated.MutationRootResolver { return &mutationRootResolver{r} }

type addToCollectionResultResolver struct{ *Resolver }
type mutationRootResolver struct{ *Resolver }
