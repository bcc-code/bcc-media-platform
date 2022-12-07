package common

import (
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
)

// StudyTaskType is the type of lesson
type StudyTaskType = string

// TaskTypes
const (
	TaskTypeQuestion             = StudyTaskType("question")
	TaskTypePoster               = StudyTaskType("poster")
	QuestionTaskTypeAlternatives = QuestionTaskType("alternatives")
	QuestionTaskTypeText         = QuestionTaskType("text")
)

// QuestionTaskType "alternatives" "text"
type QuestionTaskType = string

// StudyTopic is a topic for studying something specific
type StudyTopic struct {
	ID    uuid.UUID
	Title LocaleString
}

// GetKey returns the key for this item
func (i StudyTopic) GetKey() uuid.UUID {
	return i.ID
}

// Lesson is a lesson within a topic
type Lesson struct {
	ID      uuid.UUID
	TopicID uuid.UUID
	Title   LocaleString
}

// GetKey returns the key for this item
func (i Lesson) GetKey() uuid.UUID {
	return i.ID
}

// Task is the struct for Tasks
type Task struct {
	ID           uuid.UUID
	LessonID     uuid.UUID
	Title        LocaleString
	Type         StudyTaskType
	QuestionType QuestionTaskType
	MultiSelect  null.Bool
	Alternatives []QuestionAlternative
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
