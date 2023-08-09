package crowdin

// Object is the base of all responses in Crowdin
type Object[T any] struct {
	Data T `json:"data"`
}

// Pagination contains simple pagination data
type Pagination struct {
	Limit  int `json:"limit"`
	Offset int `json:"offset"`
}

// Result extends Object with Pagination data
type Result[T any] struct {
	Object[T]
	Pagination Pagination
}

// Language model
type Language struct {
	ID string `json:"id"`
}

// Project model
type Project struct {
	ID               int        `json:"id"`
	SourceLanguageId string     `json:"sourceLanguageId"`
	TargetLanguages  []Language `json:"targetLanguages"`
}

// Directory model
type Directory struct {
	ID    int    `json:"id,omitempty"`
	Name  string `json:"name"`
	Title string `json:"title,omitempty"`
}

// File model
type File struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Title       string `json:"title"`
	DirectoryID int    `json:"directoryId"`
}

// StringTranslation model
type StringTranslation struct {
	StringID      int    `json:"stringId"`
	TranslationID int    `json:"translationId"`
	Text          string `json:"text"`
}

// String model
type String struct {
	ID         int    `json:"id"`
	FileID     int    `json:"fileId"`
	Text       string `json:"text"`
	Identifier string `json:"identifier"`
	Context    string `json:"context"`
	IsHidden   bool   `json:"isHidden"`
}

// Approval model
type Approval struct {
	ID            int    `json:"id"`
	TranslationID int    `json:"translationId"`
	StringID      int    `json:"stringId"`
	LanguageID    string `json:"languageId"`
}
