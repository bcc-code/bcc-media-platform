package sqlc

import (
	"fmt"
)

func (file *DirectusFile) GetImageUrl() string {
	if !file.FilenameDisk.Valid {
		return ""
	}
	return fmt.Sprintf("https://brunstadtv.imgix.net/%s", file.FilenameDisk.ValueOrZero())
}
