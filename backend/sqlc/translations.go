package sqlc

import (
	"encoding/json"
	"github.com/google/uuid"
	"strconv"
)

func rawMessageToMap(msg json.RawMessage) map[string]string {
	var r map[string]string
	_ = json.Unmarshal(msg, &r)
	if r == nil {
		r = map[string]string{}
	}
	return r
}

// OriginalTranslationRow are original translations
type OriginalTranslationRow struct {
	ID     uuid.UUID
	Values json.RawMessage
}

// GetKey for this item
func (r OriginalTranslationRow) GetKey() string {
	return r.ID.String()
}

// GetParentKey for this item
func (r OriginalTranslationRow) GetParentKey() string {
	return r.ID.String()
}

// GetValues for this entry
func (r OriginalTranslationRow) GetValues() map[string]string {
	return rawMessageToMap(r.Values)
}

// GetLanguage for this item
func (r OriginalTranslationRow) GetLanguage() string {
	return "no"
}

// Int32TranslationRow is a common structure for all int32 translation rows
type Int32TranslationRow struct {
	ID       int32           `db:"id" json:"id"`
	ParentID int32           `db:"parent_id" json:"parentId"`
	Language string          `db:"language" json:"language"`
	Values   json.RawMessage `db:"values" json:"values"`
}

// GetKey for this item
func (r Int32TranslationRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r Int32TranslationRow) GetParentKey() string {
	return strconv.Itoa(int(r.ParentID))
}

// GetValues for this entry
func (r Int32TranslationRow) GetValues() map[string]string {
	return rawMessageToMap(r.Values)
}

// GetLanguage for this item
func (r Int32TranslationRow) GetLanguage() string {
	return r.Language
}

// UuidTranslationRow is a common structure for all uuid translation rows
type UuidTranslationRow struct {
	ID       int32           `db:"id" json:"id"`
	ParentID uuid.UUID       `db:"parent_id" json:"parentId"`
	Language string          `db:"language" json:"language"`
	Values   json.RawMessage `db:"values" json:"values"`
}

// GetKey for this item
func (r UuidTranslationRow) GetKey() string {
	return strconv.Itoa(int(r.ID))
}

// GetParentKey for this item
func (r UuidTranslationRow) GetParentKey() string {
	return r.ParentID.String()
}

// GetValues for this entry
func (r UuidTranslationRow) GetValues() map[string]string {
	return rawMessageToMap(r.Values)
}

// GetLanguage for this item
func (r UuidTranslationRow) GetLanguage() string {
	return r.Language
}
