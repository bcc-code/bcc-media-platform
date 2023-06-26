package members

import (
	"github.com/google/uuid"
	"time"
)

type result[t any] struct {
	Data t `json:"data"`
}

// Member is a member with related data
type Member struct {
	PersonID      int
	BirthDate     string
	Email         string
	EmailVerified bool   `json:"emailVerified"`
	DisplayName   string `json:"displayName"`
	FirstName     string `json:"firstName"`
	Gender        string `json:"gender"`
	Affiliations  []Affiliation
}

// Affiliation is an affiliation to an entity
type Affiliation struct {
	Active    bool
	OrgUid    uuid.UUID
	PersonUid uuid.UUID
	Uid       uuid.UUID
	Type      string
	ValidFrom *time.Time
	ValidTo   *time.Time
}

// Organization contains organizational data
type Organization struct {
	OrgID int
	Name  string `json:"districtName"`
	Type  string
	Uid   uuid.UUID
}
