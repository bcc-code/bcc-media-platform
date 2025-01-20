package translations

import (
	"gopkg.in/guregu/null.v4"
)

type TitleDescriptionTranslation struct {
	Title       string
	Description null.String
}

type MediaItemTranslation struct {
	Title       null.String
	Description null.String
}

type TitleTranslation struct {
	Title null.String
}

type SurveyTranslations struct {
	Title       string
	Description null.String
	Questions   []TitleWithId `json:"questions,omitempty"`
}

type StudyQuestions struct {
	Question    string
	Description null.String
	Answers     []TitleWithId `json:"answers,omitempty"`
}

type FAQTranslations struct {
	Question string
	Answer   string
}

type EpisodesTranslations struct {
	Title       string
	Description null.String
	Context     string `json:"@context"`
}

type TitleWithId struct {
	Title string
	ID    string `json:"@id"`
}
