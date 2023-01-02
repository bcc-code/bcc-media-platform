package members

import (
	"context"
	"fmt"
	"github.com/cloudevents/sdk-go/v2/event/datacodec/json"
)

// Lookup returns a member from the members api
func (c *Client) Lookup(ctx context.Context, personID int) (*Member, error) {
	return get[Member](ctx, c, fmt.Sprintf("persons/%d", personID))
}

func (c *Client) RetrieveByEmails(ctx context.Context, emails []string) (*[]Member, error) {
	filter := struct {
		Email map[string]any `json:"email"`
	}{
		Email: map[string]any{
			"_in": emails,
		},
	}

	encoded, _ := json.Encode(ctx, filter)

	return get[[]Member](ctx, c, fmt.Sprintf("persons?filter=%s", encoded))
}
