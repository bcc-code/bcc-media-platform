package common

import (
	"encoding/json"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
	"time"
)

type hasKey[k comparable] interface {
	GetKey() k
}

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

// GetKey returns the key for this item
func (s Show) GetKey() int {
	return s.ID
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

// GetKey returns the key for this item
func (s Season) GetKey() int {
	return s.ID
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

// GetKey returns the key for this item
func (s Episode) GetKey() int {
	return s.ID
}

// Page is the definition of the Page object
type Page struct {
	ID          int
	Code        string
	Published   bool
	Title       LocaleString
	Description LocaleString
}

// GetKey returns the key for this item
func (s Page) GetKey() int {
	return s.ID
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

// GetKey returns the key for this item
func (s Section) GetKey() int {
	return s.ID
}

// Collection is the definition of the Collection object
type Collection struct {
	ID         int
	Name       string
	Type       string
	Collection null.String
	Filter     *json.RawMessage
}

// GetKey returns the key for this item
func (s Collection) GetKey() int {
	return s.ID
}

// CollectionItem is the definition of the CollectionItem object
type CollectionItem struct {
	ID           int
	Sort         int
	CollectionID int
	Type         string
	ItemID       int
}

// GetKey returns the key for this item
func (s CollectionItem) GetKey() int {
	return s.ID
}
