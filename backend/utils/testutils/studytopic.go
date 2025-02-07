package testutils

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
	"testing"
)

func CreateRandomStudyTopic(t *testing.T, ctx context.Context, q *sqlc.Queries) uuid.UUID {
	t.Helper()

	st, err := q.CreateStudyTopic(ctx, sqlc.CreateStudyTopicParams{
		Status:               string(common.StatusPublished),
		UserCreated:          DefaultUser,
		Title:                "Random title",
		Description:          null.String{},
		TranslationsRequired: true,
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	err = q.UpdateStudyTopicTranslation(ctx, sqlc.UpdateStudyTopicTranslationParams{
		Description: null.NewString("description", true),
		Title:       null.NewString("title", true),
		ItemID:      st,
		Language:    "no",
	})

	return st
}

func CreateRandomLesson(t *testing.T, ctx context.Context, q *sqlc.Queries, topicID uuid.UUID) uuid.UUID {
	t.Helper()

	l, err := q.CreateLesson(ctx, sqlc.CreateLessonParams{
		Status:               string(common.StatusPublished),
		UserCreated:          DefaultUser,
		Title:                "Random title",
		TopicID:              topicID,
		Sort:                 null.NewInt(1, true),
		Description:          null.String{},
		TranslationsRequired: false,
		IntroScreenCode:      null.String{},
		ShowDiscoverPage:     false,
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	return l
}

func CreateRandomAchievement(t *testing.T, ctx context.Context, q *sqlc.Queries) uuid.UUID {
	t.Helper()

	ag, err := q.CreateAchievementGroup(ctx, sqlc.CreateAchievementGroupParams{
		UserCreated: DefaultUser,
		Title:       null.NewString("Random title", true),
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	a, err := q.CreateAchievement(ctx, sqlc.CreateAchievementParams{
		Status:      string(common.StatusPublished),
		UserCreated: DefaultUser,
		GroupID:     ag,
		Title:       "",
		Description: null.NewString("Random description", true),
		Sort:        null.NewInt(1, true),
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	return a
}

func CreateCondition(t *testing.T, ctx context.Context, q *sqlc.Queries, achivementID uuid.UUID, collection string, action string, amount int, studytopics []uuid.UUID) uuid.UUID {
	t.Helper()

	cond, err := q.CreateCondition(ctx, sqlc.CreateConditionParams{
		Collection:    collection,
		Action:        action,
		Amount:        null.NewInt(int64(amount), amount > 0),
		AchievementID: achivementID,
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	for _, st := range studytopics {
		err = q.AddStudytopicFilterToCondition(ctx, sqlc.AddStudytopicFilterToConditionParams{
			ConditionID:  cond,
			StudytopicID: st,
		})
		if err != nil {
			t.Log(err)
			t.FailNow()
		}
	}

	return cond
}

func CreateTask(t *testing.T, ctx context.Context, q *sqlc.Queries, lessonID uuid.UUID) uuid.UUID {
	t.Helper()

	taskID, err := q.CreateTask(ctx, sqlc.CreateTaskParams{
		UserCreated:  DefaultUser,
		LessonID:     lessonID,
		QuestionType: null.NewString("alternatives", true),
		Title:        null.NewString("Random title", true),
		Type:         "alternatives",
		Status:       string(common.StatusPublished),
	})

	if err != nil {
		t.Log(err)
		t.FailNow()
	}

	return taskID
}
