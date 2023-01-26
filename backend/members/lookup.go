package members

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
)

// Lookup returns a member from the members api
func (c *Client) Lookup(ctx context.Context, personID int) (*Member, error) {
	return get[Member](ctx, c, fmt.Sprintf("persons/%d", personID))
}

type retrieveByEmailRequestFilter struct {
	Email map[string]any `json:"email"`
}

// RetrieveByEmails retrieves members by emails
func (c *Client) RetrieveByEmails(ctx context.Context, emails []string) (*[]Member, error) {
	filter := retrieveByEmailRequestFilter{
		Email: map[string]any{
			"_in": emails,
		},
	}

	encoded, _ := json.Marshal(filter)

	return get[[]Member](ctx, c, fmt.Sprintf("persons?filter=%s", encoded))
}

type listOfMembersByIDFilter struct {
	PersonID map[string]any `json:"personID"`
}

// RetrieveByEmails retrieves members by emails
func (c *Client) RetrieveByID(ctx context.Context, ids []int) (*[]Member, error) {
	filter := listOfMembersByIDFilter{
		PersonID: map[string]any{
			"_in": ids,
		},
	}

	encoded, _ := json.Marshal(filter)

	return get[[]Member](ctx, c, fmt.Sprintf("persons?limit=999&fields=personID,age,affiliations.*&filter=%s", encoded))
}

// CountMembersByAge counts active members who are min <= age <= max
func (c *Client) CountMembersByAge(ctx context.Context, min, max int) (int, error) {
	filter := gin.H{
		"age": gin.H{
			"_gte": min,
			"_lte": max,
		},
	}

	encoded, _ := json.Marshal(filter)

	cnt := 0
	page := 1
	for {
		print(".")
		ms, err := get[[]Member](ctx, c, fmt.Sprintf("persons?limit=999&page=%d&fields=age,affiliations.*&filter=%s", page, encoded))
		if err != nil {
			return 0, err
		}

		// Are we done?
		if len(*ms) == 0 {
			return cnt, nil
		}

		// Remove inactive members
		activeMembers := lo.Filter(*ms, func(m Member, _ int) bool {
			return lo.ContainsBy(m.Affiliations, func(af Affiliation) bool {
				return af.OrgType == "Church" && af.Active
			})
		})

		// Add to total and next page
		cnt += len(activeMembers)
		page += 1
	}
}
