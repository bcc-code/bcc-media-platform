package common

import (
	"github.com/google/uuid"
	"time"
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
	ID        uuid.UUID
	ProfileID uuid.UUID
	Title     string
	Metadata  UserCollectionMetadata
	UpdatedAt time.Time
	CreatedAt time.Time
}

// UserCollectionMetadata contains options that can specify extra options for a user
type UserCollectionMetadata struct {
	MyList bool
}

// UserCollectionEntry is an entry in a user collection
type UserCollectionEntry struct {
	ID     uuid.UUID
	Type   string
	ItemID uuid.UUID
	Sort   int
}
