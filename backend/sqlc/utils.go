package sqlc

import (
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"gopkg.in/guregu/null.v4"
)

func toLocaleString(msg json.RawMessage, withOriginal null.String) common.LocaleString {
	r := unmarshalTo[common.LocaleString](msg)
	if withOriginal.Valid {
		r["no"] = withOriginal
	}
	return r
}

func unmarshalTo[T any](msg json.RawMessage) T {
	var r T
	_ = json.Unmarshal(msg, &r)
	return r
}
