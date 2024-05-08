package files

import (
	"context"
	"io"
)

type UploadFileParams struct {
	File io.Reader
}

type File struct {
	ID       string
	Storage  string
	FilePath string
}

type Service interface {
	UploadFile(context.Context, UploadFileParams) (File, error)
}
