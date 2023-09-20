package asset

// Chapter contains data for a chapter
type Chapter struct {
	ChapterType    string
	Timestamp      float64
	Label          string
	Title          string
	Description    string
	SongCollection string
	SongNumber     string
	Highlight      bool
	Persons        []string
}

// IngestFileMeta is the JSON structure for the ingest JSON file
type IngestFileMeta struct {
	Mime             string `json:"mime"`
	Path             string `json:"path"`
	AudioLanguge     string `json:"audiolanguage"`
	SubtitleLanguage string `json:"subtitlelanguage"`
	Resolution       string `json:"resolution"`
}

// IngestJSONMeta is the JSON structure for the ingest JSON file
type IngestJSONMeta struct {
	Duration string           `json:"duration"`
	Title    string           `json:"title"`
	ID       string           `json:"id"`
	SmilFile string           `json:"smil_file"`
	Files    []IngestFileMeta `json:"files"`
	BasePath string

	DurationInS int64
}
