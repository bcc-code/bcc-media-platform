package common

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
	"github.com/orsinium-labs/enum"

	"gopkg.in/guregu/null.v4"
)

// StreamServiceAzureMedia Various media services that we have available
const (
	StreamServiceAzureMedia = "azure_media_services"
	//StreamServiceMediapackage = "mediapackage"
)

// ItemCollection is what type of item current struct is
type ItemCollection enum.Member[string]

// Types of items
var (
	CollectionUnknown     = ItemCollection{"unknown"}
	CollectionShows       = ItemCollection{"shows"}
	CollectionSeasons     = ItemCollection{"seasons"}
	CollectionEpisodes    = ItemCollection{"episodes"}
	CollectionPages       = ItemCollection{"pages"}
	CollectionGames       = ItemCollection{"games"}
	CollectionLinks       = ItemCollection{"links"}
	CollectionPlaylists   = ItemCollection{"playlists"}
	CollectionStudyTopics = ItemCollection{"studytopics"}
	CollectionShorts      = ItemCollection{"shorts"}
	CollectionPersons     = ItemCollection{"persons"}
	Collections           = enum.New(
		CollectionUnknown,
		CollectionShows,
		CollectionSeasons,
		CollectionEpisodes,
		CollectionPages,
		CollectionGames,
		CollectionLinks,
		CollectionPlaylists,
		CollectionStudyTopics,
		CollectionShorts,
		CollectionPersons,
	)
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
	RelatedCollectionID     null.Int     `json:"relatedCollectionId"`
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
	ID                    int       `json:"id"`
	UUID                  uuid.UUID `json:"uuid"`
	Status                Status    `json:"unlisted"`
	Type                  string    `json:"type"`
	PreventPublicIndexing bool      `json:"preventPublicIndexing"`
	LegacyID              null.Int  `json:"legacyId"`
	LegacyProgramID       null.Int  `json:"legacyProgramId"`
	SeasonID              null.Int  `json:"seasonId"`
	ProductionDateInTitle bool      `json:"publishDateInTitle"`
	PublishDate           time.Time `json:"publishDate"`
	ProductionDate        time.Time `json:"productionDate"`
	AvailableFrom         time.Time `json:"availableFrom"`
	AvailableTo           time.Time `json:"availableTo"`
	Number                null.Int  `json:"number"`
	Duration              int       `json:"duration"`
	AgeRating             string    `json:"ageRating"`

	AssetID      null.Int       `json:"assetId"`
	Assets       LocaleMap[int] `json:"assets"`
	AssetVersion string         `json:"assetVersion"`

	Images           Images      `json:"images"`
	TagIDs           []int       `json:"tagIds"`
	TimedMetadataIDs []uuid.UUID `json:"timedMetadataIds"`

	PublicTitle      null.String  `json:"publicTitle"`
	Title            LocaleString `json:"title"`
	Description      LocaleString `json:"description"`
	ExtraDescription LocaleString `json:"extraDescription"`
	NumberInTitle    bool         `json:"numberInTitle"`

	ContentType null.String `json:"contentType"`
	Audience    null.String `json:"audience"`
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
	Resolution       string      `json:"resolution"`
	Size             int         `json:"size"`
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
	ConfigurationId   null.String `json:"configurationId"`
}

type ContentType enum.Member[string]

var OrderedContentTypes = []ContentType{
	ContentTypeSpeech,
	ContentTypeInterview,
	ContentTypeTheme,
	ContentTypeSong,
	ContentTypeOther,
	ContentTypeSingAlong,
}
var (
	ContentTypeSong      = ContentType{Value: "song"}
	ContentTypeSpeech    = ContentType{Value: "speech"}
	ContentTypeTestimony = ContentType{Value: "testimony"}
	ContentTypeSingAlong = ContentType{Value: "sing_along"}
	ContentTypeOther     = ContentType{Value: "other"}
	ContentTypeTheme     = ContentType{Value: "theme"}
	ContentTypeInterview = ContentType{Value: "interview"}
	ContentTypes         = enum.New(OrderedContentTypes...)
)

// TimedMetadata item type
type TimedMetadata struct {
	ID          uuid.UUID
	Type        string
	Timestamp   float64
	Duration    float64
	Title       LocaleString `json:"title"`
	Description LocaleString `json:"description"`
	ContentType ContentType
	PersonIDs   []uuid.UUID
	SongID      uuid.NullUUID
	MediaItemID uuid.NullUUID
	Images      Images
}

// Short item type
type Short struct {
	ID          uuid.UUID
	MediaID     uuid.UUID
	AssetID     null.Int
	Title       LocaleString
	Description LocaleString
	Images      Images
	EpisodeID   null.Int
	StartsAt    null.Float
	EndsAt      null.Float
	Label       string
	Status      Status
	DateUpdated time.Time
	TagIDs      []int
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
	Limit              int
}

// GetKey returns the key for this item
func (i Section) GetKey() int {
	return i.ID
}

// Collection is the definition of the Collection object
type Collection struct {
	ID             int          `json:"id"`
	Slugs          LocaleString `json:"slugs"`
	Title          LocaleString `json:"title"`
	Type           string       `json:"type"`
	AdvancedType   null.String  `json:"advancedType"`
	Filter         *Filter      `json:"filter"`
	NumberInTitles bool         `json:"numberInTitles"`
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
	GroupID             uuid.UUID
	Default             bool
	Code                string
	ClientVersion       string
	DefaultPageID       null.Int
	SearchPageID        null.Int
	GamesPageID         null.Int
	RelatedCollectionID null.Int
	SupportEmail        null.String
	Roles               []string
	LivestreamRoles     []string
}

// GetKey returns the key for this item
func (i Application) GetKey() int {
	return i.ID
}

// ApplicationGroup contains data for
type ApplicationGroup struct {
	ID    uuid.UUID
	Roles []string
}

// GetKey returns the key for this item
func (i ApplicationGroup) GetKey() uuid.UUID {
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

// Game contains details for a game
type Game struct {
	ID           uuid.UUID `json:"id"`
	Title        LocaleString
	Description  LocaleString
	Images       Images
	Url          string
	RequiresAuth bool
}

// Song contains some metadata for songs
type Song struct {
	ID    uuid.UUID
	Title LocaleString
}

// Person contains some metadata for people
type Person struct {
	ID     uuid.UUID
	Name   string
	Images Images
}

// Phrase is a key value pair for translations
type Phrase struct {
	Key   string
	Value LocaleString
}

// Playlist is a collection of items
type Playlist struct {
	ID           uuid.UUID
	CollectionID null.Int
	Title        LocaleString
	Description  LocaleString
	Images       Images
}

// GetKey returns the key for this item
func (i Playlist) GetKey() uuid.UUID {
	return i.ID
}

// MediaProgress is the profile progress for a specific media item
type MediaProgress struct {
	ProfileID uuid.UUID `json:"profileId"`
	MediaID   uuid.UUID `json:"itemId"`
	Progress  float64   `json:"progress"`
	Duration  float64   `json:"duration"`
	Watched   int       `json:"watched"`
	WatchedAt null.Time `json:"watchedAt"`
	UpdatedAt time.Time `json:"updatedAt"`
	FromStart bool      `json:"fromStart"`
}
