package common

import "github.com/google/uuid"

type Contribution struct {
	ItemID   string    `json:"itemId"`
	ItemType string    `json:"itemType"`
	Type     string    `json:"type"`
	PersonID uuid.UUID `json:"personId"`
}
type ContributionType struct {
	Code  string       `json:"code"`
	Title LocaleString `json:"title"`
}

type ContributionTypeCount struct {
	Type  string `json:"type"`
	Count int    `json:"count"`
}
