package asset

// Chapter contains data for a chapter
type Chapter struct {
	ChapterType    string   `json:"chapter_type"`
	Timestamp      float64  `json:"timestamp"`
	Label          string   `json:"label"`
	Title          string   `json:"title"`
	Description    string   `json:"description"`
	SongCollection string   `json:"song_collection"`
	SongNumber     string   `json:"song_number"`
	Highlight      bool     `json:"highlight"`
	Persons        []string `json:"persons"`
}

// IngestFileMeta is the JSON structure for the ingest JSON file
type IngestFileMeta struct {
	Mime             string `json:"mime"`
	Path             string `json:"path"`
	AudioLanguage    string `json:"audiolanguage"`
	SubtitleLanguage string `json:"subtitlelanguage"`
	Resolution       string `json:"resolution"`
}

// IngestJSONMeta is the JSON structure for the ingest JSON file
type IngestJSONMeta struct {
	Duration    string `json:"duration"`
	DurationInS int64

	Title        string           `json:"title"`
	ID           string           `json:"id"`
	SmilFile     string           `json:"smil_file"`
	ChaptersFile string           `json:"chapters_file"`
	Files        []IngestFileMeta `json:"files"`
	BasePath     string           `json:"base_path"`
	Source       string           `json:"source"`
}
