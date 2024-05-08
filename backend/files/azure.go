package files

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
)

type azureFileService struct {
	queries   *sqlc.Queries
	container string
}

func (s *azureFileService) UploadFile(ctx context.Context, params UploadFileParams) (File, error) {
	// TODO: Dump the file into root of the container with github.com/Azure/azure-sdk-for-go/sdk/storage/azblob
	filenameDisk := ""

	s.queries.InsertDirectusFile(ctx, sqlc.InsertDirectusFileParams{
		Storage:      "azure",
		FilenameDisk: filenameDisk,
	})

	return File{
		Storage:  "azure",
		FilePath: filenameDisk,
	}, nil
}

func NewAzureFileService(container string, queries *sqlc.Queries) Service {
	return &azureFileService{
		container: container,
		queries:   queries,
	}
}
