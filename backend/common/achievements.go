package common

import (
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
	"time"
)

// Achievement is the struct for achievements.sql
type Achievement struct {
	ID          uuid.UUID
	Title       LocaleString
	Description LocaleString
	Images      LocaleMap[null.String]
	GroupID     uuid.NullUUID
	Conditions  []AchievementCondition
}

// GetKey returns key for this item
func (a Achievement) GetKey() uuid.UUID {
	return a.ID
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

// GetKey returns key for this item
func (a AchievementGroup) GetKey() uuid.UUID {
	return a.ID
}

// Achieved struct
type Achieved struct {
	ID          uuid.UUID
	AchievedAt  time.Time
	ConfirmedAt null.Time
}

// GetKey returns key for this item
func (a Achieved) GetKey() uuid.UUID {
	return a.ID
}
