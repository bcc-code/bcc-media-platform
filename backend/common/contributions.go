package common

import (
	"github.com/google/uuid"
	"github.com/orsinium-labs/enum"
)

type Contribution struct {
	ItemID      string    `json:"itemId"`
	ItemType    string    `json:"itemType"`
	MediaItemID uuid.UUID `json:"mediaItemId"`
	Type        string    `json:"type"`
	PersonID    uuid.UUID `json:"personId"`
	ContentType string    `json:"contentType"`
}
type ContributionType enum.Member[string]

var (
	ContributionTypeLyricist = ContributionType{"lyricist"}
	ContributionTypeArranger = ContributionType{"arranger"}
	ContributionTypeSinger   = ContributionType{"singer"}
	ContributionTypeSpeaker  = ContributionType{"speaker"}
	ContributionTypeUnknown  = ContributionType{"unknown"}
	ContributionTypes        = enum.New(
		ContributionTypeLyricist,
		ContributionTypeArranger,
		ContributionTypeSinger,
		ContributionTypeSpeaker,
		ContributionTypeUnknown,
	)
)
