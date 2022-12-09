package crowdin2

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
)

// List retrieves all translations
func (c *Client) List(ctx context.Context, collection string) map[string]common.LocaleMap[string] {
	res, err := get(ctx, c, "")
}
