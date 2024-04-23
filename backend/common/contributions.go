package common

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
	Type  string `json:"type"`
	Count int    `json:"count"`
}
