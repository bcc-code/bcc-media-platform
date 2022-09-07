package members

import (
	"context"
	"fmt"
)

// Lookup returns a member from the members api
func (c *Client) Lookup(ctx context.Context, personID int) (*Member, error) {
	return get[Member](ctx, c, fmt.Sprintf("persons/%d", personID))
}
