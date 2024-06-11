package files

import (
	"context"
	"io"
)

type UploadFileParams struct {
	File        io.Reader
	FileName    string
	ContentType string
	Title       *string
	Description *string
}

type File struct {
	ID          string
	Storage     string
	FilePath    string
	ContentType string
}

type Service interface {
	UploadFile(context.Context, UploadFileParams) (*File, error)
}
