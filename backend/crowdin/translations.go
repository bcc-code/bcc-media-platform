package crowdin

import (
	"fmt"
	"github.com/davecgh/go-spew/spew"
)

func (client *Client) RetrieveAllTranslations() error {
	for _, id := range client.config.ProjectIDs {
		body := fmt.Sprintf(`{"exportApprovedOnly": true}`)

		res, err := post[Object[struct {
			Status string `json:"status"`
		}]](client, fmt.Sprintf("projects/%d/translations/builds", id), body)
		if err != nil {
			return err
		}

		spew.Dump(res.Data)
	}
	return nil
}
