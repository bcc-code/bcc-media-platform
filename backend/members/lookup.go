package members

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/google/uuid"

	"github.com/ansel1/merry/v2"
	"github.com/samber/lo"
)

const (
	personFields = "*,affiliations.*"
	orgFields    = "districtName,type,orgID,uid"
)

// Lookup returns a member from the members api
func (c *Client) Lookup(ctx context.Context, personID int) (*Member, error) {
	return get[Member](ctx, c, fmt.Sprintf("v2/persons/%d?fields=%s", personID, personFields))
}

// RetrieveByEmails retrieves members by emails
func (c *Client) RetrieveByEmails(ctx context.Context, emails []string) (*[]Member, error) {
	filter := map[string]any{
		"email": map[string]any{
			"_in": emails,
		},
	}

	encoded, _ := json.Marshal(filter)

	return get[[]Member](ctx, c, fmt.Sprintf("v2/persons?filter=%s&fields=%s", encoded, personFields))
}

// GetMembersByIDs retrieves a batch of members by ID
func (c *Client) GetMembersByIDs(ctx context.Context, ids []int) ([]Member, error) {
	chunkedIds := lo.Chunk(ids, 800)
	var out []Member

	for _, chunk := range chunkedIds {
		filter := map[string]any{
			"personID": map[string]any{
				"_in": chunk,
			},
		}

		encoded, _ := json.Marshal(filter)

		ms, err := get[[]Member](ctx, c, fmt.Sprintf("v2/persons?limit=999&filter=%s&fields=%s", encoded, personFields))
		if err != nil {
			return nil, merry.Wrap(err)

		}

		out = append(out, *ms...)
	}

	return out, nil
}

// GetOrganizationsByIDs returns organizations by IDs.
func (c *Client) GetOrganizationsByIDs(ctx context.Context, ids []uuid.UUID) ([]Organization, error) {
	chunkedIds := lo.Chunk(ids, 800)
	var out []Organization

	for _, chunk := range chunkedIds {
		filter := map[string]any{
			"uid": map[string]any{
				"_in": chunk,
			},
		}

		encoded, _ := json.Marshal(filter)

		ms, err := get[[]Organization](ctx, c, fmt.Sprintf("v2/orgs?limit=999&filter=%s&fields=%s", encoded, orgFields))
		if err != nil {
			return nil, merry.Wrap(err)

		}

		out = append(out, *ms...)
	}

	return out, nil
}
