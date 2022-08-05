package common

import (
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
	"time"
)

// Show is the definition of the Show object
type Show struct {
	ID            int
	Published     bool
	AvailableFrom time.Time
	AvailableTo   time.Time
	Roles         Roles
	Title         LocaleString
	Description   LocaleString
	ImageID       uuid.NullUUID
}

// Season is the definition of the Season object
type Season struct {
	ID            int
	Published     bool
	Number        int
	AvailableFrom time.Time
	AvailableTo   time.Time
	Roles         Roles
	Title         LocaleString
	Description   LocaleString
	ShowID        int
	ImageID       uuid.NullUUID
}

// Episode is the definition of the Episode object
type Episode struct {
	ID               int
	Published        bool
	AvailableFrom    time.Time
	AvailableTo      time.Time
	Roles            Roles
	SeasonID         null.Int
	Number           null.Int
	AssetID          null.Int
	ImageID          uuid.NullUUID
	TagIDs           []int
	Title            LocaleString
	Description      LocaleString
	ExtraDescription LocaleString
}

// Page is the definition of the Page object
type Page struct {
	ID          int
	Code        string
	Published   bool
	Title       LocaleString
	Description LocaleString
}

// Section is the definition of the Section object
type Section struct {
	ID           int
	Sort         int
	PageID       int
	Type         string
	Title        LocaleString
	Description  LocaleString
	Style        string
	CollectionID int
	Roles        []string
}

// Collection is the definition of the Collection object
type Collection struct {
	ID         int
	Name       string
	Type       string
	Collection null.String
	Filter     null.String
}

// CollectionItem is the definition of the CollectionItem object
type CollectionItem struct {
	ID           int
	CollectionID int
	Type         string
	ItemID       int
}
