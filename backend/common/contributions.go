package common

import "github.com/google/uuid"

type ContributionType string

type Contribution struct {
	ID       int32            `json:"id"`
	ItemID   string           `json:"itemId"`
	ItemType string           `json:"itemType"`
	Type     ContributionType `json:"type"`
	PersonID string           `json:"personId"`
}

type ContributionTypeCount struct {
	PersonId uuid.UUID        `json:"personId"`
	Type     ContributionType `json:"type"`
	Count    int              `json:"count"`
}
