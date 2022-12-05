package studies

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
)

// TaskType is the type of lesson
type TaskType = string

// TaskTypes
const (
	TaskTypeQuestion             = TaskType("question")
	TaskTypePoster               = TaskType("poster")
	QuestionTaskTypeAlternatives = QuestionTaskType("alternatives")
	QuestionTaskTypeText         = QuestionTaskType("text")
)

// QuestionTaskType "alternatives" "text"
type QuestionTaskType = string

// Topic is a topic for studying something specific
type Topic struct {
	ID    uuid.UUID
	Title common.LocaleString
}

// Lesson is a lesson within a topic
type Lesson struct {
	ID      uuid.UUID
	TopicID uuid.UUID
	Title   common.LocaleString
}

// Task is the struct for Tasks
type Task struct {
	ID           uuid.UUID
	LessonID     uuid.UUID
	Title        common.LocaleString
	Type         TaskType
	QuestionType QuestionTaskType
	MultiSelect  null.Bool
}

// QuestionAlternative is an alternative for a question
type QuestionAlternative struct {
	ID    uuid.UUID
	Title common.LocaleString
}
