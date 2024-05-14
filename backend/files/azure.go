package files

import (
	"context"
	"fmt"

	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
)

type azureFileService struct {
	queries   *sqlc.Queries
	client    *azblob.Client
	container string
}
type AzureConfig struct {
	AccountName string
	AccountKey  string
	Container   string
}

func (s *azureFileService) UploadFile(ctx context.Context, params UploadFileParams) (File, error) {
	if params.File == nil || params.FileName == "" {
		return File{}, fmt.Errorf("file and filename are required")
	}

	_, err := s.client.UploadStream(ctx, s.container, params.FileName, params.File, nil)
	if err != nil {
		return File{}, err
	}

	randomId, err := uuid.NewRandom()
	if err != nil {
		return File{}, err
	}

	id, err := s.queries.InsertDirectusFile(ctx, sqlc.InsertDirectusFileParams{
		ID:           randomId,
		Storage:      "az",
		FilenameDisk: params.FileName,
		Type:         null.StringFrom(params.ContentType),
	})
	if err != nil {
		return File{}, err
	}

	return File{
		ID:          id.String(),
		Storage:     "az",
		FilePath:    params.FileName,
		ContentType: params.ContentType,
	}, nil
}

func NewAzureFileService(queries *sqlc.Queries, config AzureConfig) (Service, error) {
	cred, err := azblob.NewSharedKeyCredential(config.AccountName, config.AccountKey)
	if err != nil {
		return nil, err
	}
	client, err := azblob.NewClientWithSharedKeyCredential(fmt.Sprintf("https://%s.blob.core.windows.net/", config.AccountName), cred, nil)
	if err != nil {
		return nil, err
	}
	return &azureFileService{
		client:    client,
		queries:   queries,
		container: config.Container,
	}, nil
}
