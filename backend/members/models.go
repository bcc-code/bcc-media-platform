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
	Active    bool       `json:"isActive"`
	OrgUid    uuid.UUID  `json:"orgUid"`
	PersonUid uuid.UUID  `json:"personUid"`
	Uid       uuid.UUID  `json:"uid"`
	Type      string     `json:"type"`
	ValidFrom *time.Time `json:"validFrom"`
	ValidTo   *time.Time `json:"validTo"`
}

// IsActive returns true if the affiliation is currently active
func (a Affiliation) IsActive() bool {
	if !a.Active {
		return false
	}
	now := time.Now()
	if a.ValidFrom != nil && now.Before(*a.ValidFrom) {
		return false
	}
	if a.ValidTo != nil && !now.Before(*a.ValidTo) {
		return false
	}
	return true
}

// HasActiveAffiliation returns true if any affiliation in the slice is active
func HasActiveAffiliation(affiliations []Affiliation) bool {
	for _, a := range affiliations {
		if a.IsActive() {
			return true
		}
	}
	return false
}

// Organization contains organizational data
type Organization struct {
	OrgID int
	Name  string `json:"districtName"`
	Type  string
	Uid   uuid.UUID
}
