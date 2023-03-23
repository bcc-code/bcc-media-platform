package analytics

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"math"
	"math/rand"
	"strconv"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
)

// GenerateID for use in analytics based on profileID
func GenerateID(profileID uuid.UUID, key string) string {

	// The next 1 if is there for now to guard against paths that could possibly
	// deliver bogus values. They should not be removed unless there is a strong guarantee
	// that they, but especially the key, can NOT be empty

	if key == "" {
		log.L.Warn().Msg("Key passed to GenerateID is empty. Setting random key")
		key = strconv.Itoa(int(rand.Int63n(math.MaxInt64)))
	}

	// We hash the person ID first to get a more "lively" hash, otherwise it is possible
	// to deduce (at least it was with empty key) what relative personID has been encoded
	// in a HMAC if you know one (and you know yours).
	hashedPersonID := sha256.Sum256([]byte(profileID.String()))
	h := hmac.New(sha256.New, []byte(key))
	sum := h.Sum(hashedPersonID[:]) // [:] converts from a fixed size array to a slice
	return base64.StdEncoding.EncodeToString(sum)
}
