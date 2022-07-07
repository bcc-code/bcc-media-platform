package sqlc

import "fmt"

func (file *DirectusFile) GetImageUrl() string {
	return fmt.Sprintf("https://brunstadtv.imgix.net/%s", file.FilenameDisk.ValueOrZero())
}
