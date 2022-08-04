package search

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/sqlc"
)

func (service *Service) showToSearchItem(_ context.Context, show sqlc.ShowExpanded) (searchItem, error) {
	var title common.LocaleString
	var description common.LocaleString
	_ = json.Unmarshal(show.Title, &title)
	_ = json.Unmarshal(show.Description, &description)

	var item = searchItem{
		ID:          "show-" + strconv.Itoa(int(show.ID)),
		Title:       title,
		Description: description,
		Header:      nil,
		Type:        "show",
	}
	return item, nil
}
