package sqlc

import (
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"gopkg.in/guregu/null.v4"
)

func toLocaleString(msg json.RawMessage, original string) common.LocaleString {
	var r = common.LocaleString{}
	if original != "" {
		_ = json.Unmarshal(msg, &r)
		r["no"] = null.StringFrom(original)
	}
	return r
}

func unmarshalTo[T any](msg json.RawMessage) T {
	var r T
	_ = json.Unmarshal(msg, &r)
	return r
}
