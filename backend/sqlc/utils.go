package sqlc

import (
	"encoding/json"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"gopkg.in/guregu/null.v4"
)

// localeString decodes a translations blob into a LocaleString.
//
// The result is always a usable map, never nil: callers routinely write a
// fallback into it (title["no"] = ...) straight afterwards, and json.Unmarshal
// leaves a map nil both when the column holds JSON null and when decoding fails.
//
// A decode failure yields an empty map rather than an error. There is no way to
// surface one from the row mappers, and a single unreadable translation should
// not fail the whole query — but it is logged, because the alternative is
// content silently rendering with no title.
func localeString(msg json.RawMessage) common.LocaleString {
	r := common.LocaleString{}
	if len(msg) == 0 {
		return r
	}
	if err := json.Unmarshal(msg, &r); err != nil {
		log.L.Warn().Err(err).Str("value", string(msg)).Msg("Failed to decode translations")
		return common.LocaleString{}
	}
	if r == nil {
		return common.LocaleString{}
	}
	return r
}

func toLocaleString(msg json.RawMessage, original string) common.LocaleString {
	var r = common.LocaleString{}
	if original != "" {
		r = localeString(msg)
		r["no"] = null.StringFrom(original)
	}
	return r
}

// unmarshalTo decodes msg into T, returning the zero value if it cannot.
//
// Not for map types — use localeString for LocaleString — since the zero value
// of a map is nil and callers that write into the result would panic.
func unmarshalTo[T any](msg json.RawMessage) T {
	var r T
	if len(msg) == 0 {
		return r
	}
	if err := json.Unmarshal(msg, &r); err != nil {
		log.L.Warn().Err(err).Str("value", string(msg)).Msgf("Failed to decode %T", r)
	}
	return r
}
