package crowdin

type Object[T any] struct {
	Data T
}

type Pagination struct {
	Limit  int `json:"limit"`
	Offset int `json:"offset"`
}

type Result[T any] struct {
	Object[T]
	Pagination Pagination
}

type Language struct {
	ID string `json:"id"`
}

type Project struct {
	ID               int        `json:"id"`
	SourceLanguageId string     `json:"sourceLanguageId"`
	TargetLanguages  []Language `json:"targetLanguages"`
}

type Directory struct {
	ID    int    `json:"id,omitempty"`
	Name  string `json:"name"`
	Title string `json:"title,omitempty"`
}

type File struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Title       string `json:"title"`
	DirectoryID int    `json:"directoryId"`
}

type Translation struct {
	StringID      int    `json:"stringId"`
	TranslationID int    `json:"translationId"`
	Text          string `json:"text"`
}

type String struct {
	ID         int    `json:"id"`
	FileID     int    `json:"fileId"`
	Text       string `json:"text"`
	Identifier string `json:"identifier"`
}

type Approval struct {
	ID            int    `json:"id"`
	TranslationID int    `json:"translationId"`
	StringID      int    `json:"stringId"`
	LanguageID    string `json:"languageId"`
}
