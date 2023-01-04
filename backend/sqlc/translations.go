package sqlc

import "strconv"

// GetKey for this item
func (r ListEpisodeTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListEpisodeTranslationsRow) GetParentKey() string {
	return strconv.Itoa(int(r.ParentID))
}

// GetValues for this entry
func (r ListEpisodeTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListEpisodeTranslationsRow) GetLanguage() string {
	return r.LanguagesCode
}

// GetKey for this item
func (r ListSeasonTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListSeasonTranslationsRow) GetParentKey() string {
	return strconv.Itoa(int(r.ParentID))
}

// GetValues for this entry
func (r ListSeasonTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListSeasonTranslationsRow) GetLanguage() string {
	return r.LanguagesCode
}

// GetKey for this item
func (r ListShowTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListShowTranslationsRow) GetParentKey() string {
	return strconv.Itoa(int(r.ParentID))
}

// GetValues for this entry
func (r ListShowTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListShowTranslationsRow) GetLanguage() string {
	return r.LanguagesCode
}

// GetKey for this item
func (r ListPageTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListPageTranslationsRow) GetParentKey() string {
	return strconv.Itoa(int(r.ParentID.Int64))
}

// GetValues for this entry
func (r ListPageTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListPageTranslationsRow) GetLanguage() string {
	return r.LanguagesCode.String
}

// GetKey for this item
func (r ListSectionTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListSectionTranslationsRow) GetParentKey() string {
	return strconv.Itoa(int(r.ParentID))
}

// GetValues for this entry
func (r ListSectionTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListSectionTranslationsRow) GetLanguage() string {
	return r.LanguagesCode
}

// GetKey for this item
func (r ListStudyTopicTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListStudyTopicTranslationsRow) GetParentKey() string {
	return r.ParentID.UUID.String()
}

// GetValues for this entry
func (r ListStudyTopicTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListStudyTopicTranslationsRow) GetLanguage() string {
	return r.LanguagesCode.String
}

// GetKey for this item
func (r ListLessonTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListLessonTranslationsRow) GetParentKey() string {
	return r.ParentID.UUID.String()
}

// GetValues for this entry
func (r ListLessonTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListLessonTranslationsRow) GetLanguage() string {
	return r.LanguagesCode.String
}

// GetKey for this item
func (r ListTaskTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListTaskTranslationsRow) GetParentKey() string {
	return r.ParentID.UUID.String()
}

// GetValues for this entry
func (r ListTaskTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListTaskTranslationsRow) GetLanguage() string {
	return r.LanguagesCode.String
}

// GetKey for this item
func (r ListAlternativeTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListAlternativeTranslationsRow) GetParentKey() string {
	return r.ParentID.UUID.String()
}

// GetValues for this entry
func (r ListAlternativeTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	return ret
}

// GetLanguage for this item
func (r ListAlternativeTranslationsRow) GetLanguage() string {
	return r.LanguagesCode
}

// GetKey for this item
func (r ListAchievementTranslationsRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r ListAchievementTranslationsRow) GetParentKey() string {
	return r.ParentID.UUID.String()
}

// GetValues for this entry
func (r ListAchievementTranslationsRow) GetValues() map[string]string {
	ret := map[string]string{}

	if r.Title.Valid {
		ret["title"] = r.Title.String
	}

	if r.Description.Valid {
		ret["description"] = r.Description.String
	}

	return ret
}

// GetLanguage for this item
func (r ListAchievementTranslationsRow) GetLanguage() string {
	return r.LanguagesCode
}
