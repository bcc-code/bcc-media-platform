package common

import (
	"encoding/json"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
)

type hasKey[k comparable] interface {
	GetKey() k
}

// Show is the definition of the Show object
type Show struct {
	ID           int
	Availability Availability
	Roles        Roles
	Title        LocaleString
	Description  LocaleString
	ImageID      uuid.NullUUID
}

// GetKey returns the key for this item
func (i Show) GetKey() int {
	return i.ID
}

// GetRoles returns roles for this item
func (i Show) GetRoles() Roles {
	return i.Roles
}

// GetAvailability returns Availability for this item
func (i Show) GetAvailability() Availability {
	return i.Availability
}

// GetImage returns id of attached image
func (i Show) GetImage() uuid.NullUUID {
	return i.ImageID
}

// Season is the definition of the Season object
type Season struct {
	ID           int
	Number       int
	Availability Availability
	Roles        Roles
	Title        LocaleString
	Description  LocaleString
	ShowID       int
	ImageID      uuid.NullUUID
}

// GetKey returns the key for this item
func (i Season) GetKey() int {
	return i.ID
}

// GetRoles returns roles for this item
func (i Season) GetRoles() Roles {
	return i.Roles
}

// GetAvailability returns Availability for this item
func (i Season) GetAvailability() Availability {
	return i.Availability
}

// GetImage returns id of attached image
func (i Season) GetImage() uuid.NullUUID {
	return i.ImageID
}

// Episode is the definition of the Episode object
type Episode struct {
	ID               int
	Availability     Availability
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
func (i Episode) GetKey() int {
	return i.ID
}

// GetRoles returns roles for this item
func (i Episode) GetRoles() Roles {
	return i.Roles
}

// GetAvailability returns Availability for this item
func (i Episode) GetAvailability() Availability {
	return i.Availability
}

// GetImage returns id of attached image
func (i Episode) GetImage() uuid.NullUUID {
	return i.ImageID
}

// GetTagIDs returns ids of related tags
func (i Episode) GetTagIDs() []int {
	return i.TagIDs
}

// File item type
type File struct {
	ID               int
	Type             string
	EpisodeID        int
	AssetID          int
	AudioLanguage    null.String
	SubtitleLanguage null.String
	Path             string
	Storage          string
	MimeType         string
}

// Stream item type
type Stream struct {
	ID                int
	Type              string
	EpisodeID         int
	AssetID           int
	AudioLanguages    []string
	SubtitleLanguages []string
	Path              string
	Service           string
	Url               string
	EncryptionKeyID   null.String
}

// Page is the definition of the Page object
type Page struct {
	ID           int
	Roles        Roles
	Availability Availability
	Code         string
	Title        LocaleString
	Description  LocaleString
}

// GetKey returns the key for this item
func (i Page) GetKey() int {
	return i.ID
}

// GetAvailability returns Availability for this item
func (i Page) GetAvailability() Availability {
	return i.Availability
}

// GetRoles returns roles for this item
func (i Page) GetRoles() Roles {
	return i.Roles
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
	CollectionID null.Int
	Roles        []string
}

// GetKey returns the key for this item
func (i Section) GetKey() int {
	return i.ID
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
func (i Collection) GetKey() int {
	return i.ID
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

// Tag struct
type Tag struct {
	ID   int
	Code string
	Name LocaleString
}

// GetKey returns the key for this item
func (i Tag) GetKey() int {
	return i.ID
}
