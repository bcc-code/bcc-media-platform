package common

import (
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
)

// StudyTaskType is the type of lesson
type StudyTaskType = string

// QuestionTaskType "alternatives" "text"
type QuestionTaskType = string

// ImageTaskType "poster" "quote"
type ImageTaskType = string

// TaskTypes
const (
	TaskTypeQuestion = StudyTaskType("question")
	TaskTypeImage    = StudyTaskType("image")
	TaskTypeVideo    = StudyTaskType("video")
	TaskTypeLink     = StudyTaskType("link")

	QuestionTaskTypeAlternatives = QuestionTaskType("alternatives")
	QuestionTaskTypeText         = QuestionTaskType("text")

	ImageTaskTypePoster = ImageTaskType("poster")
	ImageTaskTypeQuote  = ImageTaskType("quote")
)

// StudyTopic is a topic for studying something specific
type StudyTopic struct {
	ID          uuid.UUID
	Title       LocaleString
	Description LocaleString
	Images      Images
}

// GetKey returns the key for this item
func (i StudyTopic) GetKey() uuid.UUID {
	return i.ID
}

// Lesson is a lesson within a topic
type Lesson struct {
	ID          uuid.UUID
	TopicID     uuid.UUID
	Title       LocaleString
	Description LocaleString
	Images      Images
}

// GetKey returns the key for this item
func (i Lesson) GetKey() uuid.UUID {
	return i.ID
}

// Task is the struct for Tasks
type Task struct {
	ID              uuid.UUID
	LessonID        uuid.UUID
	Title           LocaleString
	Type            StudyTaskType
	QuestionType    QuestionTaskType
	ImageType       ImageTaskType
	LinkID          null.Int
	EpisodeID       null.Int
	Images          LocaleMap[string]
	MultiSelect     null.Bool
	CompetitionMode bool
	Alternatives    []QuestionAlternative
	SecondaryTitle  LocaleString
	Description     LocaleString
}

// GetKey returns the key for this item
func (i Task) GetKey() uuid.UUID {
	return i.ID
}

// QuestionAlternative is an alternative for a question
type QuestionAlternative struct {
	ID        uuid.UUID
	TaskID    uuid.UUID
	Title     LocaleString
	IsCorrect bool
}

// GetKey returns the key for this item
func (i QuestionAlternative) GetKey() uuid.UUID {
	return i.ID
}

// SelectedAlternatives is a struct for getting selected alternatives of a question
type SelectedAlternatives struct {
	ID       uuid.UUID
	Selected []uuid.UUID
	Locked   bool
}

// GetKey returns the key for this item
func (sa SelectedAlternatives) GetKey() uuid.UUID {
	return sa.ID
}

// AlternativesTasksProgress is a struct for getting the count of correct and
// available "multiple choice" tasks
type AlternativesTasksProgress struct {
	ID             uuid.UUID
	TotalTasks     int
	CompletedTasks int
	CorrectTasks   int
}

// GetKey returns the key for this item
func (sa AlternativesTasksProgress) GetKey() uuid.UUID {
	return sa.ID
}
