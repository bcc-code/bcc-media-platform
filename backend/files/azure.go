package files

import (
	"bytes"
	"context"
	"fmt"
	"image"
	_ "image/gif"
	_ "image/jpeg"
	_ "image/png"
	"io"

	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob"
	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob/blob"
	"github.com/Azure/azure-sdk-for-go/sdk/storage/azblob/blockblob"
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

func (s *azureFileService) UploadFile(ctx context.Context, params UploadFileParams) (*File, error) {
	if params.File == nil || params.FileName == "" {
		return nil, fmt.Errorf("file and filename are required")
	}

	var err error
	buffer := &bytes.Buffer{}
	tee := io.TeeReader(params.File, buffer)

	_, err = s.client.UploadStream(ctx, s.container, params.FileName, tee, &blockblob.UploadStreamOptions{
		HTTPHeaders: &blob.HTTPHeaders{
			BlobContentType: &params.ContentType,
		},
	})
	if err != nil {
		return nil, err
	}

	var width, height int
	if params.ContentType == "image/jpeg" || params.ContentType == "image/png" {
		width, height, err = getImageDimensions(buffer)
		if err != nil {
			return nil, err
		}
	}

	randomId, err := uuid.NewRandom()
	if err != nil {
		return nil, err
	}

	id, err := s.queries.InsertDirectusFile(ctx, sqlc.InsertDirectusFileParams{
		ID:           randomId,
		Storage:      "az",
		FilenameDisk: params.FileName,
		Type:         null.StringFrom(params.ContentType),
		Width:        null.IntFrom(int64(width)),
		Height:       null.IntFrom(int64(height)),
		Title:        null.StringFromPtr(params.Title),
		Description:  null.StringFromPtr(params.Description),
	})
	if err != nil {
		return nil, err
	}

	return &File{
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

func getImageDimensions(reader io.Reader) (width, height int, err error) {
	// Decode the image to get the image.Config which contains width and height
	config, _, err := image.DecodeConfig(reader)
	if err != nil {
		return 0, 0, err
	}
	return config.Width, config.Height, nil
}
