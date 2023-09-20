package sqlc

import (
	"encoding/json"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/samber/lo"
)

type sqlImage struct {
	Style        string `json:"style"`
	Language     string `json:"language"`
	FilenameDisk string `json:"filename_disk"`
}

func (q *Queries) getImages(jsonMessage json.RawMessage) common.Images {
	var imageArray []sqlImage
	_ = json.Unmarshal(jsonMessage, &imageArray)
	return lo.Reduce[sqlImage, common.Images](imageArray, func(m common.Images, i sqlImage, _ int) common.Images {
		existing, ok := m[i.Style]
		if !ok {
			existing = common.LocaleMap[string]{}
			m[i.Style] = existing
		}
		existing[i.Language] = q.filenameToImageURL(i.FilenameDisk)
		return m
	}, common.Images{})
}

func (q *Queries) filenameToImageURL(filename string) string {
	return fmt.Sprintf("https://%s/%s", q.getImageCDNDomain(), filename)
}
