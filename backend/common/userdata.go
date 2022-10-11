package common

import (
	"github.com/google/uuid"
	"time"
)

type Profile struct {
	ID     uuid.UUID
	UserID string
	Name   string
}

type Device struct {
	Token     string
	ProfileID uuid.UUID
	UpdatedAt time.Time
	Name      string
}
