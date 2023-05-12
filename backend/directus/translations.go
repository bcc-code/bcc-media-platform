package directus

import (
	"context"
	"fmt"
	"github.com/bcc-code/mediabank-bridge/log"
	"strconv"
)

// Translation model
type Translation struct {
	ID            int    `json:"id,omitempty"`
	Title         string `json:"title"`
	Description   string `json:"description"`
	LanguagesCode string `json:"languages_code"`
	//IsPrimary     bool   `json:"is_primary"`
}

// EpisodesTranslation extends Translation
type EpisodesTranslation struct {
	Translation
	EpisodesID int `json:"episodes_id"`
}

// SeasonsTranslation extends Translation
type SeasonsTranslation struct {
	Translation
	SeasonsID int `json:"seasons_id"`
}

// ShowsTranslation extends Translation
type ShowsTranslation struct {
	Translation
	ShowsID int `json:"shows_id"`
}

// SectionsTranslation extends Translation
type SectionsTranslation struct {
	Translation
	SectionsID int `json:"sections_id"`
}

// PagesTranslation extends Translation
type PagesTranslation struct {
	Translation
	PagesID int `json:"pages_id"`
}

// LinksTranslation extends Translation
type LinksTranslation struct {
	Translation
	LinksID int `json:"links_id"`
}

// StudyTopicsTranslation struct
type StudyTopicsTranslation struct {
	ID            string `json:"id,omitempty"`
	Title         string `json:"title"`
	Description   string `json:"description,omitempty"`
	LanguagesCode string `json:"languages_code"`
	StudyTopicsID string `json:"studytopics_id"`
}

// LessonsTranslation struct
type LessonsTranslation struct {
	ID            string `json:"id,omitempty"`
	Title         string `json:"title"`
	Description   string `json:"description,omitempty"`
	LanguagesCode string `json:"languages_code"`
	LessonsID     string `json:"lessons_id"`
}

// TasksTranslation struct
type TasksTranslation struct {
	ID            string `json:"id,omitempty"`
	Title         string `json:"title"`
	Description   string `json:"description,omitempty"`
	LanguagesCode string `json:"languages_code"`
	TasksID       string `json:"tasks_id"`
}

// QuestionAlternativesTranslation struct
type QuestionAlternativesTranslation struct {
	ID                     string `json:"id,omitempty"`
	Title                  string `json:"title"`
	LanguagesCode          string `json:"languages_code"`
	QuestionAlternativesID string `json:"questionalternatives_id"`
}

// AchievementsTranslation struct
type AchievementsTranslation struct {
	ID             string `json:"id,omitempty"`
	Title          string `json:"title"`
	Description    string `json:"description,omitempty"`
	LanguagesCode  string `json:"languages_code"`
	AchievementsID string `json:"achievements_id"`
}

// AchievementGroupsTranslation struct
type AchievementGroupsTranslation struct {
	ID                  string `json:"id,omitempty"`
	Title               string `json:"title"`
	LanguagesCode       string `json:"languages_code"`
	AchievementGroupsID string `json:"achievementgroups_id"`
}

// FaqsTranslation struct
type FaqsTranslation struct {
	ID            string `json:"id,omitempty"`
	Question      string `json:"question"`
	Answer        string `json:"answer"`
	LanguagesCode string `json:"languages_code"`
	FaqsID        string `json:"faqs_id"`
}

// FaqCategoriesTranslation struct
type FaqCategoriesTranslation struct {
	ID              string `json:"id,omitempty"`
	Title           string `json:"title"`
	Description     string `json:"description"`
	LanguagesCode   string `json:"languages_code"`
	FaqCategoriesID string `json:"faqcategories_id"`
}

// SurveysTranslation struct
type SurveysTranslation struct {
	ID            string `json:"id,omitempty"`
	Title         string `json:"title"`
	Description   string `json:"description,omitempty"`
	LanguagesCode string `json:"languages_code"`
	SurveysID     string `json:"surveys_id"`
}

// SurveyQuestionsTranslation struct
type SurveyQuestionsTranslation struct {
	ID                string `json:"id,omitempty"`
	Title             string `json:"title"`
	Description       string `json:"description"`
	LanguagesCode     string `json:"languages_code"`
	Placeholder       string `json:"placeholder"`
	SurveyQuestionsID string `json:"surveyquestions_id"`
}

// ForUpdate for update
func (i SurveysTranslation) ForUpdate() any {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

// UID for unique id
func (i SurveysTranslation) UID() string {
	return i.ID
}

// TypeName string
func (SurveysTranslation) TypeName() string {
	return "surveys_translations"
}

// ForUpdate for update
func (i SurveyQuestionsTranslation) ForUpdate() any {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
		"placeholder": i.Placeholder,
	}
}

// UID for unique id
func (i SurveyQuestionsTranslation) UID() string {
	return i.ID
}

// TypeName string
func (SurveyQuestionsTranslation) TypeName() string {
	return "surveyquestions_translations"
}

// ForUpdate for update
func (i StudyTopicsTranslation) ForUpdate() any {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

// UID for unique id
func (i StudyTopicsTranslation) UID() string {
	return i.ID
}

// TypeName string
func (StudyTopicsTranslation) TypeName() string {
	return "studytopics_translations"
}

// ForUpdate for update
func (i LessonsTranslation) ForUpdate() any {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

// UID unique id
func (i LessonsTranslation) UID() string {
	return i.ID
}

// TypeName string
func (LessonsTranslation) TypeName() string {
	return "lessons_translations"
}

// ForUpdate for update
func (i TasksTranslation) ForUpdate() any {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

// UID unique id
func (i TasksTranslation) UID() string {
	return i.ID
}

// TypeName string
func (TasksTranslation) TypeName() string {
	return "tasks_translations"
}

// ForUpdate for update
func (i QuestionAlternativesTranslation) ForUpdate() any {
	return map[string]string{
		"title": i.Title,
	}
}

// UID unique id
func (i QuestionAlternativesTranslation) UID() string {
	return i.ID
}

// TypeName string
func (QuestionAlternativesTranslation) TypeName() string {
	return "questionalternatives_translations"
}

// ForUpdate for update
func (i AchievementsTranslation) ForUpdate() any {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

// UID unique id
func (i AchievementsTranslation) UID() string {
	return i.ID
}

// TypeName string
func (AchievementsTranslation) TypeName() string {
	return "achievements_translations"
}

// ForUpdate for update
func (i AchievementGroupsTranslation) ForUpdate() any {
	return map[string]string{
		"title": i.Title,
	}
}

// UID unique id
func (i AchievementGroupsTranslation) UID() string {
	return i.ID
}

// TypeName string
func (AchievementGroupsTranslation) TypeName() string {
	return "achievementgroups_translations"
}

// ForUpdate for update
func (i FaqsTranslation) ForUpdate() any {
	return map[string]string{
		"question": i.Question,
		"answer":   i.Answer,
	}
}

// UID unique id
func (i FaqsTranslation) UID() string {
	return i.ID
}

// TypeName string
func (FaqsTranslation) TypeName() string {
	return "faqs_translations"
}

// ForUpdate for update
func (i FaqCategoriesTranslation) ForUpdate() any {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

// UID unique id
func (i FaqCategoriesTranslation) UID() string {
	return i.ID
}

// TypeName string
func (FaqCategoriesTranslation) TypeName() string {
	return "faqcategories_translations"
}

type update struct {
	Title       string `json:"title"`
	Description string `json:"description"`
}

// UID retrieves the not so unique ID (except internally in Collection)
func (i Translation) UID() string {
	if i.ID == 0 {
		return ""
	}
	return strconv.Itoa(i.ID)
}

// ForUpdate retrieves a struct with mutable properties
func (i Translation) ForUpdate() interface{} {
	return update{
		i.Title,
		i.Description,
	}
}

// TypeName episodes_translations
func (EpisodesTranslation) TypeName() string {
	return "episodes_translations"
}

// TypeName seasons_translations
func (SeasonsTranslation) TypeName() string {
	return "seasons_translations"
}

// TypeName shows_translations
func (ShowsTranslation) TypeName() string {
	return "shows_translations"
}

// TypeName shows_translations
func (SectionsTranslation) TypeName() string {
	return "sections_translations"
}

// TypeName shows_translations
func (PagesTranslation) TypeName() string {
	return "pages_translations"
}

// TypeName shows_translations
func (LinksTranslation) TypeName() string {
	return "links_translations"
}

// GetLanguage retrieves the configured language for this translation
func (i Translation) GetLanguage() string {
	return i.LanguagesCode
}

// GetValues retrieves a map with the values used in translations
func (i Translation) GetValues() map[string]string {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

// GetCollection episodes
func (i EpisodesTranslation) GetCollection() string {
	return "episodes"
}

// GetItemID retrieves parentId
func (i EpisodesTranslation) GetItemID() int {
	return i.EpisodesID
}

// GetCollection seasons
func (i SeasonsTranslation) GetCollection() string {
	return "seasons"
}

// GetItemID retrieves parentId
func (i SeasonsTranslation) GetItemID() int {
	return i.SeasonsID
}

// GetCollection shows
func (i ShowsTranslation) GetCollection() string {
	return "shows"
}

// GetItemID retrieves parentId
func (i ShowsTranslation) GetItemID() int {
	return i.ShowsID
}

// GetEpisodeTranslation retrieves a translation by id
func (h *Handler) GetEpisodeTranslation(ctx context.Context, id int) (translation EpisodesTranslation) {
	translation, err := GetItem[EpisodesTranslation](ctx, h.c, "episodes_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

// GetSeasonTranslation retrieves a translation by id
func (h *Handler) GetSeasonTranslation(ctx context.Context, id int) (translation SeasonsTranslation) {
	translation, err := GetItem[SeasonsTranslation](ctx, h.c, "seasons_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

// GetShowTranslation retrieves a translation by id
func (h *Handler) GetShowTranslation(ctx context.Context, id int) (translation ShowsTranslation) {
	translation, err := GetItem[ShowsTranslation](ctx, h.c, "shows_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

func initListQueryParams(language string, primary bool, parentId int, parentProperty string) map[string]string {
	params := map[string]string{}
	if language != "" {
		params["filter[languages_code][_eq]"] = language
	}
	if primary {
		params["filter[is_primary][_eq]"] = "true"
	}
	if parentId != 0 {
		params[fmt.Sprintf("filter[%s][_eq]", parentProperty)] = strconv.Itoa(parentId)
	}
	return params
}

func listTranslations[t DSItem](ctx context.Context, h *Handler, collection string, queryParams map[string]string) (translations []t, err error) {
	return ListItems[t](ctx, h.c, collection, queryParams)
}

// ListEpisodeTranslations lists translations (for language, as primary or with episodeId)
func (h *Handler) ListEpisodeTranslations(ctx context.Context, language string, primary bool, episodeId int) ([]EpisodesTranslation, error) {
	return listTranslations[EpisodesTranslation](ctx, h, "episodes_translations",
		initListQueryParams(language, primary, episodeId, "episodes_id"),
	)
}

// ListSeasonTranslations lists translations (for language, as primary or with episodeId)
func (h *Handler) ListSeasonTranslations(ctx context.Context, language string, primary bool, seasonId int) ([]SeasonsTranslation, error) {
	return listTranslations[SeasonsTranslation](ctx, h, "seasons_translations",
		initListQueryParams(language, primary, seasonId, "seasons_id"),
	)
}

// ListShowTranslations lists translations (for language, as primary or with episodeId)
func (h *Handler) ListShowTranslations(ctx context.Context, language string, primary bool, showId int) ([]ShowsTranslation, error) {
	return listTranslations[ShowsTranslation](ctx, h, "shows_translations",
		initListQueryParams(language, primary, showId, "shows_id"),
	)
}

// SaveTranslations saves translations (or other DS items)
func (h *Handler) SaveTranslations(ctx context.Context, translations []DSItem) error {
	return SaveItems(ctx, h.c, translations)
}
