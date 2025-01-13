package common

import "encoding/json"

type TranslationData struct {
	Language string
	Value    json.RawMessage
	ID       string
}
