package common

import (
	"encoding/json"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
	"time"
)

// HasKey interface for items with keys
type HasKey[k comparable] interface {
	GetKey() k
}

// ItemType is what type of item current struct is
type ItemType string

// Types of items
var (
	TypeShow    = ItemType("show")
	TypeSeason  = ItemType("season")
	TypeEpisode = ItemType("episode")
)

// Relation contains a simple id to relation struct
type Relation[k comparable, kr comparable] interface {
	GetID() k
	GetRelationID() kr
}

// Show is the definition of the Show object
type Show struct {
	ID          int           `json:"id"`
	LegacyID    null.Int      `json:"legacyId"`
	Title       LocaleString  `json:"title"`
	Description LocaleString  `json:"description"`
	ImageID     uuid.NullUUID `json:"imageId"`
}

// GetKey returns the key for this item
func (i Show) GetKey() int {
	return i.ID
}

// GetImage returns id of attached image
func (i Show) GetImage() uuid.NullUUID {
	return i.ImageID
}

// IsCollectionItem declares that this implements CollectionItem interfaces
func (i Show) IsCollectionItem() {

}

// Season is the definition of the Season object
type Season struct {
	ID          int           `json:"id"`
	LegacyID    null.Int      `json:"legacyId"`
	Number      int           `json:"number"`
	Title       LocaleString  `json:"title"`
	Description LocaleString  `json:"description"`
	ShowID      int           `json:"showId"`
	ImageID     uuid.NullUUID `json:"imageId"`
}

// GetKey returns the key for this item
func (i Season) GetKey() int {
	return i.ID
}

// GetImage returns id of attached image
func (i Season) GetImage() uuid.NullUUID {
	return i.ImageID
}

// IsCollectionItem declares that this implements CollectionItem interfaces
func (i Season) IsCollectionItem() {

}

// Episode is the definition of the Episode object
type Episode struct {
	ID               int           `json:"id"`
	LegacyID         null.Int      `json:"legacyId"`
	SeasonID         null.Int      `json:"seasonId"`
	Number           null.Int      `json:"number"`
	AssetID          null.Int      `json:"assetId"`
	ImageID          uuid.NullUUID `json:"imageId"`
	TagIDs           []int         `json:"tagIds"`
	Title            LocaleString  `json:"title"`
	Description      LocaleString  `json:"description"`
	ExtraDescription LocaleString  `json:"extraDescription"`
}

// GetKey returns the key for this item
func (i Episode) GetKey() int {
	return i.ID
}

// GetImage returns id of attached image
func (i Episode) GetImage() uuid.NullUUID {
	return i.ImageID
}

// GetTagIDs returns ids of related tags
func (i Episode) GetTagIDs() []int {
	return i.TagIDs
}

// IsCollectionItem declares that this implements CollectionItem interfaces
func (i Episode) IsCollectionItem() {

}

// File item type
type File struct {
	ID               int         `json:"id"`
	Type             string      `json:"type"`
	EpisodeID        int         `json:"episodeId"`
	AssetID          int         `json:"assetId"`
	AudioLanguage    null.String `json:"audioLanguage"`
	SubtitleLanguage null.String `json:"subtitleLanguage"`
	Path             string      `json:"path"`
	Storage          string      `json:"storage"`
	MimeType         string      `json:"mimeType"`
}

// Stream item type
type Stream struct {
	ID                int         `json:"id"`
	Type              string      `json:"type"`
	EpisodeID         int         `json:"episodeId"`
	AssetID           int         `json:"assetId"`
	AudioLanguages    []string    `json:"audioLanguages"`
	SubtitleLanguages []string    `json:"subtitleLanguages"`
	Path              string      `json:"path"`
	Service           string      `json:"service"`
	Url               string      `json:"url"`
	EncryptionKeyID   null.String `json:"encryptionKeyId"`
}

// Page is the definition of the Page object
type Page struct {
	ID           int          `json:"id"`
	Roles        Roles        `json:"roles"`
	Availability Availability `json:"availability"`
	Code         string       `json:"code"`
	Title        LocaleString `json:"title"`
	Description  LocaleString `json:"description"`
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

// IsCollectionItem declares that this implements CollectionItem interfaces
func (i Page) IsCollectionItem() {

}

// Section is the definition of the Section object
type Section struct {
	ID           int          `json:"id"`
	Sort         int          `json:"sort"`
	PageID       int          `json:"pageId"`
	Type         string       `json:"type"`
	Title        LocaleString `json:"title"`
	Description  LocaleString `json:"description"`
	Style        string       `json:"style"`
	CollectionID null.Int     `json:"collectionId"`
	Roles        []string     `json:"roles"`
}

// GetKey returns the key for this item
func (i Section) GetKey() int {
	return i.ID
}

// Collection is the definition of the Collection object
type Collection struct {
	ID         int         `json:"id"`
	Name       string      `json:"name"`
	Type       string      `json:"type"`
	Collection null.String `json:"collection"`
	Filter     *Filter     `json:"filter"`
}

// GetKey returns the key for this item
func (i Collection) GetKey() int {
	return i.ID
}

// Filter struct contains filter data
type Filter struct {
	Filter          json.RawMessage
	SortBy          string
	SortByDirection string
}

// CollectionItem is the definition of the CollectionItem object
type CollectionItem struct {
	ID           int    `json:"id"`
	Sort         int    `json:"sort"`
	CollectionID int    `json:"collectionId"`
	Type         string `json:"type"`
	ItemID       int    `json:"itemId"`
}

// GetKey returns the key for this item
func (s CollectionItem) GetKey() int {
	return s.ID
}

// Tag struct
type Tag struct {
	ID   int          `json:"id"`
	Code string       `json:"code"`
	Name LocaleString `json:"name"`
}

// GetKey returns the key for this item
func (i Tag) GetKey() int {
	return i.ID
}

// Event contains details about a calendar event
type Event struct {
	ID    int
	Title LocaleString
	Start time.Time
	End   time.Time
}

// GetKey returns the key for this item
func (i Event) GetKey() int {
	return i.ID
}

// CalendarEntry contains details about a specific TvGuide entry
type CalendarEntry struct {
	ID          int
	EventID     null.Int
	Title       LocaleString
	Description LocaleString
	Start       time.Time
	End         time.Time
	Type        null.String
	ItemID      null.Int
}

// GetKey returns the key for this item
func (i CalendarEntry) GetKey() int {
	return i.ID
}
