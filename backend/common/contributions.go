package common

import "github.com/google/uuid"

type Contribution struct {
	ID       int32  `json:"id"`
	ItemID   string `json:"itemId"`
	ItemType string `json:"itemType"`
	Type     string `json:"type"`
	PersonID string `json:"personId"`
}

type ContributionType struct {
	Code  string       `json:"code"`
	Title LocaleString `json:"title"`
}

type ContributionTypeCount struct {
	PersonId uuid.UUID `json:"personId"`
	Type     string    `json:"type"`
	Count    int       `json:"count"`
}
