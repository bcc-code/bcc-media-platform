package common

import (
	"github.com/google/uuid"
)

// Achievement is the struct for achievements.sql
type Achievement struct {
	ID         uuid.UUID
	Title      LocaleString
	GroupID    uuid.NullUUID
	Conditions []AchievementCondition
}

// AchievementCondition is a condition for which an achievement should be completed
type AchievementCondition struct {
	ID         uuid.UUID
	Collection string
	Action     string
	Amount     int
}

// AchievementGroup is a group of different achievements.sql
type AchievementGroup struct {
	ID    uuid.UUID
	Title LocaleString
}
