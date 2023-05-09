package common

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"

	"gopkg.in/guregu/null.v4"
)

// StreamServiceAzureMedia Various media services that we have available
const (
	StreamServiceAzureMedia = "azure_media_services"
	//StreamServiceMediapackage = "mediapackage"
)

// ItemCollection is what type of item current struct is
type ItemCollection string

// Types of items
var (
	TypeShow    = ItemCollection("shows")
	TypeSeason  = ItemCollection("seasons")
	TypeEpisode = ItemCollection("episodes")
	TypePage    = ItemCollection("pages")
	TypeSection = ItemCollection("sections")
)

// Show is the definition of the Show object
type Show struct {
	ID                      int          `json:"id"`
	Status                  Status       `json:"status"`
	Type                    string       `json:"type"`
	TagIDs                  []int        `json:"tagIds"`
	LegacyID                null.Int     `json:"legacyId"`
	PublicTitle             null.String  `json:"publicTitle"`
	Title                   LocaleString `json:"title"`
	Description             LocaleString `json:"description"`
	Image                   null.String  `json:"image"`
	Images                  Images       `json:"images"`
	DefaultEpisodeBehaviour null.String  `json:"defaultEpisode"`
}

// GetKey returns the key for this item
func (i Show) GetKey() int {
	return i.ID
}

// GetTagIDs returns ids of related tags
func (i Show) GetTagIDs() []int {
	return i.TagIDs
}

// Unlisted returns true if item is unlisted
func (i Show) Unlisted() bool {
	return i.Status == StatusUnlisted
}

// GetStatus returns the status for this item
func (i Show) GetStatus() Status {
	return i.Status
}

// Season is the definition of the Season object
type Season struct {
	ID          int          `json:"id"`
	Status      Status       `json:"status"`
	LegacyID    null.Int     `json:"legacyId"`
	TagIDs      []int        `json:"tagIds"`
	Number      int          `json:"number"`
	AgeRating   string       `json:"ageRating"`
	PublicTitle null.String  `json:"publicTitle"`
	Title       LocaleString `json:"title"`
	Description LocaleString `json:"description"`
	ShowID      int          `json:"showId"`
	Image       null.String  `json:"image"`
	Images      Images       `json:"images"`
}

// GetKey returns the key for this item
func (i Season) GetKey() int {
	return i.ID
}

// GetTagIDs returns ids of related tags
func (i Season) GetTagIDs() []int {
	return i.TagIDs
}

// Unlisted returns true if item is unlisted
func (i Season) Unlisted() bool {
	return i.Status == StatusUnlisted
}

// GetStatus returns the status for this item
func (i Season) GetStatus() Status {
	return i.Status
}

// Episode is the definition of the Episode object
type Episode struct {
	ID                    int          `json:"id"`
	UUID                  uuid.UUID    `json:"uuid"`
	Status                Status       `json:"unlisted"`
	Type                  string       `json:"type"`
	PreventPublicIndexing bool         `json:"preventPublicIndexing"`
	LegacyID              null.Int     `json:"legacyId"`
	LegacyProgramID       null.Int     `json:"legacyProgramId"`
	SeasonID              null.Int     `json:"seasonId"`
	PublishDateInTitle    bool         `json:"publishDateInTitle"`
	PublishDate           time.Time    `json:"publishDate"`
	ProductionDate        time.Time    `json:"productionDate"`
	AvailableFrom         time.Time    `json:"availableFrom"`
	AvailableTo           time.Time    `json:"availableTo"`
	Number                null.Int     `json:"number"`
	Duration              int          `json:"duration"`
	AgeRating             string       `json:"ageRating"`
	AssetID               null.Int     `json:"assetId"`
	Image                 null.String  `json:"image"`
	Images                Images       `json:"images"`
	TagIDs                []int        `json:"tagIds"`
	PublicTitle           null.String  `json:"publicTitle"`
	Title                 LocaleString `json:"title"`
	Description           LocaleString `json:"description"`
	ExtraDescription      LocaleString `json:"extraDescription"`
}

// GetKey returns the key for this item
func (i Episode) GetKey() int {
	return i.ID
}

// GetTagIDs returns ids of related tags
func (i Episode) GetTagIDs() []int {
	return i.TagIDs
}

// Unlisted returns true if item is unlisted
func (i Episode) Unlisted() bool {
	return i.Status == StatusUnlisted
}

// GetStatus returns the status for this item
func (i Episode) GetStatus() Status {
	return i.Status
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
	ID          int          `json:"id"`
	Code        string       `json:"code"`
	Title       LocaleString `json:"title"`
	Description LocaleString `json:"description"`
	Images      Images       `json:"images"`
}

// GetKey returns the key for this item
func (i Page) GetKey() int {
	return i.ID
}

// Link contains link data
type Link struct {
	ID                  int           `json:"id"`
	Title               LocaleString  `json:"title"`
	Description         LocaleString  `json:"description"`
	URL                 string        `json:"url"`
	Images              Images        `json:"images"`
	Type                LinkType      `json:"type"`
	ComputedDataGroupID uuid.NullUUID `json:"computedDataGroupId"`
}

// LinkType is the general type of the link
type LinkType = string

// GetKey returns the key for this item
func (i Link) GetKey() int {
	return i.ID
}

// Section is the definition of the Section object
type Section struct {
	ID                  int            `json:"id"`
	Sort                int            `json:"sort"`
	PageID              int            `json:"pageId"`
	Type                string         `json:"type"`
	ShowTitle           bool           `json:"showTitle"`
	Title               LocaleString   `json:"title"`
	Description         LocaleString   `json:"description"`
	Style               string         `json:"style"`
	Size                string         `json:"size"`
	CollectionID        null.Int       `json:"collectionId"`
	MessageID           null.Int       `json:"messageId"`
	EmbedUrl            null.String    `json:"embedUrl"`
	EmbedAspectRatio    null.Float     `json:"embedAspectRatio"`
	EmbedHeight         null.Int       `json:"embedHeight"`
	NeedsAuthentication null.Bool      `json:"needsAuthentication"`
	Options             SectionOptions `json:"options"`
}

// SectionOptions contains options for this section
type SectionOptions struct {
	SecondaryTitles    bool
	MyList             bool
	ContinueWatching   bool
	UseContext         bool
	PrependLiveElement bool
}

// GetKey returns the key for this item
func (i Section) GetKey() int {
	return i.ID
}

// Collection is the definition of the Collection object
type Collection struct {
	ID           int          `json:"id"`
	Slugs        LocaleString `json:"slugs"`
	Title        LocaleString `json:"title"`
	Type         string       `json:"type"`
	AdvancedType null.String  `json:"advancedType"`
	Filter       *Filter      `json:"filter"`
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
	Limit           *int
}

// CollectionItem is the definition of the CollectionItem object
type CollectionItem struct {
	ID           int            `json:"id"`
	Sort         int            `json:"sort"`
	CollectionID int            `json:"collectionId"`
	Type         ItemCollection `json:"type"`
	ItemID       string         `json:"itemId"`
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
	IsReplay    bool
	ItemID      null.Int
}

// GetKey returns the key for this item
func (i CalendarEntry) GetKey() int {
	return i.ID
}

// FAQCategory contains the name of the FAQ category
type FAQCategory struct {
	ID    uuid.UUID
	Title LocaleString
}

// GetKey returns the key for this item
func (i FAQCategory) GetKey() uuid.UUID {
	return i.ID
}

// Question contains question data
type Question struct {
	ID         uuid.UUID
	CategoryID uuid.UUID
	Question   LocaleString
	Answer     LocaleString
}

// GetKey returns the key for this item
func (i Question) GetKey() uuid.UUID {
	return i.ID
}

// Application contains data for
type Application struct {
	ID                  int
	UUID                uuid.UUID
	Default             bool
	Code                string
	ClientVersion       string
	DefaultPageID       null.Int
	SearchPageID        null.Int
	RelatedCollectionID null.Int
	Roles               []string
}

// GetKey returns the key for this item
func (i Application) GetKey() int {
	return i.ID
}

// MessageGroup is a group of messages
type MessageGroup struct {
	ID       int       `json:"id"`
	Enabled  bool      `json:"enabled"`
	Messages []Message `json:"messages"`
}

// GetKey returns key for this item
func (i MessageGroup) GetKey() int {
	return i.ID
}

// Message is a message
type Message struct {
	ID      int          `json:"id"`
	Style   string       `json:"style"`
	Title   LocaleString `json:"message"`
	Content LocaleString `json:"details"`
}

// Survey is a survey
type Survey struct {
	ID          uuid.UUID `json:"id"`
	Title       LocaleString
	Description LocaleString
}

// SurveyQuestion is a question in a survey
type SurveyQuestion struct {
	ID          uuid.UUID `json:"id"`
	Title       LocaleString
	Description LocaleString
	Type        string
}

// Prompt is a prompt that shows up in app
type Prompt struct {
	ID             uuid.UUID `json:"id"`
	Type           string
	Title          LocaleString
	SecondaryTitle LocaleString
	SurveyID       uuid.NullUUID
	From           time.Time
	To             time.Time
}
