package achievements

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils/testutils"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func TestCheckNewAchievements(t *testing.T) {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	db := testutils.NewDB(t)
	q := sqlc.New(db)

	ctx := context.Background()

	err := testutils.InsertDefaults(ctx, q)
	assert.NoError(t, err)

	appGroup := testutils.CreateAppGroup(t, ctx, q)

	testutils.CreateProfile(t, ctx, q, testutils.DefaultBCCUser, appGroup)
	profiles, err := q.ApplicationQueries(appGroup).GetProfilesForUserIDs(ctx, []string{testutils.DefaultBCCUser})

	assert.NoError(t, err)
	assert.Len(t, profiles, 1)

	profile := profiles[0]

	topicID := testutils.CreateRandomStudyTopic(t, ctx, q)
	topicID2 := testutils.CreateRandomStudyTopic(t, ctx, q)

	lessonID := testutils.CreateRandomLesson(t, ctx, q, topicID)
	testutils.CreateRandomLesson(t, ctx, q, topicID)
	testutils.CreateRandomLesson(t, ctx, q, topicID)

	lessonID2 := testutils.CreateRandomLesson(t, ctx, q, topicID2)
	testutils.CreateRandomLesson(t, ctx, q, topicID2)
	testutils.CreateRandomLesson(t, ctx, q, topicID2)

	achID := testutils.CreateRandomAchievement(t, ctx, q)
	testutils.CreateCondition(t, ctx, q, achID, CollectionLessons, ActionCompleted, 1, []uuid.UUID{topicID})

	achID2 := testutils.CreateRandomAchievement(t, ctx, q)
	testutils.CreateCondition(t, ctx, q, achID2, CollectionLessons, ActionCompleted, 1, []uuid.UUID{topicID2})

	taskID := testutils.CreateTask(t, ctx, q, lessonID)
	taskID2 := testutils.CreateTask(t, ctx, q, lessonID2)

	l := &loaders.BatchLoaders{
		CompletedLessonsLoader: loaders.NewRelationLoader(ctx, q.GetCompletedLessons, loaders.WithName("completed-lessons")),
		StudyLessonLoader:      loaders.New(ctx, q.GetLessons),
	}

	c, _ := gin.CreateTestContext(httptest.NewRecorder())
	ctx = context.WithValue(ctx, "GinContextKey", c)
	c.Set(user.CtxProfile, &profile)
	c.Set(user.CtxProfiles, profiles)

	err = q.SetTaskCompleted(ctx, sqlc.SetTaskCompletedParams{
		ProfileID: profile.ID,
		TaskID:    taskID,
	})
	assert.NoError(t, err)

	err = CheckNewAchievements(ctx, q, l, Action{
		Collection: CollectionLessons,
		Action:     ActionCompleted,
	})

	ach, err := q.GetAchievedAchievements(ctx, sqlc.GetAchievedAchievementsParams{
		ProfileID: profile.ID,
		AchievementIds: []uuid.UUID{
			achID,
			achID2,
		},
	})

	assert.NoError(t, err)
	assert.Len(t, ach, 1)
	assert.Equal(t, achID, ach[0])

	err = q.SetTaskCompleted(ctx, sqlc.SetTaskCompletedParams{
		ProfileID: profile.ID,
		TaskID:    taskID2,
	})
	assert.NoError(t, err)

	// Clear the cache
	l.CompletedLessonsLoader.Clear(ctx, profile.ID)

	err = CheckNewAchievements(ctx, q, l, Action{
		Collection: CollectionLessons,
		Action:     ActionCompleted,
	})

	assert.NoError(t, err)

	ach2, err := q.GetAchievedAchievements(ctx, sqlc.GetAchievedAchievementsParams{
		ProfileID: profile.ID,
		AchievementIds: []uuid.UUID{
			achID,
			achID2,
		},
	})

	assert.NoError(t, err)
	assert.Len(t, ach2, 2)
}
