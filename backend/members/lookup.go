package members

import (
	"context"
	"encoding/json"
	"fmt"
)

// Lookup returns a member from the members api
func (c *Client) Lookup(ctx context.Context, personID int) (*Member, error) {
	return get[Member](ctx, c, fmt.Sprintf("persons/%d", personID))
}

type retrieveByEmailRequestFilter struct {
	Email map[string]any `json:"email"`
}

func (c *Client) RetrieveByEmails(ctx context.Context, emails []string) (*[]Member, error) {
	filter := retrieveByEmailRequestFilter{
		Email: map[string]any{
			"_in": emails,
		},
	}

	encoded, _ := json.Marshal(filter)

	return get[[]Member](ctx, c, fmt.Sprintf("persons?filter=%s", encoded))
}
