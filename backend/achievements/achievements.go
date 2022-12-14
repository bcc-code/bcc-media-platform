package achievements

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
)

type Achievement struct {
	ID    uuid.UUID
	Title common.LocaleString
}
