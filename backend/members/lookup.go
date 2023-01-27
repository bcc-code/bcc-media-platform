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

// RetrieveByID retrieves a batch of members by ID
func (c *Client) RetrieveByID(ctx context.Context, ids []int) (*[]Member, error) {
	// TODO: We should likely allow passing any number of ids in here and chunk them internally

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
	/// TOOO: This is currenty only used by `statistician` and needs to be cleaned up, possibly limited?
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

// CountMembersByAgeGroupedByOrg counts active members who are min <= age <= max, and groups them by their active "Church"
func (c *Client) CountMembersByAgeGroupedByOrg(ctx context.Context, min, max int) (map[int]int, error) {
	/// TOOO: This is currenty only used by `statistician` and needs to be cleaned up, possibly limited?

	out := map[int]int{}
	filter := gin.H{
		"age": gin.H{
			"_gte": min,
			"_lte": max,
		},
	}

	encoded, _ := json.Marshal(filter)

	page := 1
	for {
		print(".")
		ms, err := get[[]Member](ctx, c, fmt.Sprintf("persons?limit=999&page=%d&fields=age,affiliations.*&filter=%s", page, encoded))
		if err != nil {
			return nil, err
		}

		// Are we done?
		if len(*ms) == 0 {
			return out, nil
		}

		// Can this easily be parallelized?
		// Is the += thread safe or do we have to make it better
		// Will it be faster? Do we care?
		lo.ForEach(*ms, func(m Member, _ int) {
			counted := false
			lo.ForEach(m.Affiliations, func(af Affiliation, _ int) {
				if counted || af.OrgType != "Church" || !af.Active {
					return
				}

				if _, ok := out[af.OrgID]; !ok {
					out[af.OrgID] = 0
				}
				out[af.OrgID] += 1
				counted = true
			})
		})

		// Next page
		page += 1
	}
}

// GetOrgs returns basic data about all organizations
// Meant for use by statistician
func (c *Client) GetOrgs(ctx context.Context, min, max int) ([]Organization, error) {
	page := 1
	out := []Organization{}
	for {
		print(".")
		ms, err := get[[]Organization](ctx, c, fmt.Sprintf("orgs?limit=999&page=%d&fields=orgID,name,type", page))
		if err != nil {
			return nil, err
		}

		// Are we done?
		if len(*ms) == 0 {
			return out, nil
		}

		out = append(out, *ms...)

		page += 1
	}
}
