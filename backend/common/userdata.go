package common

import (
	"time"

	"github.com/google/uuid"
)

// Profile is the entry point for most user-specific content
type Profile struct {
	ID     uuid.UUID
	UserID string
	Name   string
}

// Device is a profile-linked device with a token for notifications
type Device struct {
	Token     string
	ProfileID uuid.UUID
	UpdatedAt time.Time
	Name      string
	Languages []string
}

// UserCollection is a collection created by a user
type UserCollection struct {
	ID                 uuid.UUID
	ApplicationGroupID uuid.UUID
	ProfileID          uuid.UUID
	Title              string
	Metadata           UserCollectionMetadata
	UpdatedAt          time.Time
	CreatedAt          time.Time
}

// UserCollectionMetadata contains options that can specify extra options for a user
type UserCollectionMetadata struct {
	MyList bool `json:"myList"`
}

// UserCollectionEntry is an entry in a user collection
type UserCollectionEntry struct {
	ID           uuid.UUID
	CollectionID uuid.UUID
	Type         string
	ItemID       uuid.UUID
	Sort         int
	UpdatedAt    time.Time
	CreatedAt    time.Time
}
