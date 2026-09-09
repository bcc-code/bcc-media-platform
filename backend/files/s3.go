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

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"gopkg.in/guregu/null.v4"
)

type s3FileService struct {
	queries *sqlc.Queries
	client  *s3.Client
	bucket  string
}

// NewS3FileService uploads files to the bucket configured for Directus's s3 storage location.
func NewS3FileService(queries *sqlc.Queries, client *s3.Client, bucket string) Service {
	return &s3FileService{queries: queries, client: client, bucket: bucket}
}

func (s *s3FileService) UploadFile(ctx context.Context, params UploadFileParams) (*File, error) {
	if params.File == nil || params.FileName == "" {
		return nil, fmt.Errorf("file and filename are required")
	}

	// Buffer generated images so dimensions and upload can read independently.
	data, err := io.ReadAll(params.File)
	if err != nil {
		return nil, fmt.Errorf("read upload: %w", err)
	}
	var width, height int
	if params.ContentType == "image/jpeg" || params.ContentType == "image/png" {
		width, height, err = getImageDimensions(bytes.NewReader(data))
		if err != nil {
			return nil, fmt.Errorf("read image dimensions: %w", err)
		}
	}
	id, err := uuid.NewRandom()
	if err != nil {
		return nil, err
	}

	_, err = s.client.PutObject(ctx, &s3.PutObjectInput{
		Bucket:      aws.String(s.bucket),
		Key:         aws.String(params.FileName),
		Body:        bytes.NewReader(data),
		ContentType: aws.String(params.ContentType),
	})
	if err != nil {
		return nil, fmt.Errorf("upload file to S3: %w", err)
	}

	fileID, err := s.queries.InsertDirectusFile(ctx, sqlc.InsertDirectusFileParams{
		ID:           id,
		Storage:      "s3",
		FilenameDisk: params.FileName,
		Type:         null.StringFrom(params.ContentType),
		Width:        null.IntFrom(int64(width)),
		Height:       null.IntFrom(int64(height)),
		Title:        null.StringFromPtr(params.Title),
		Description:  null.StringFromPtr(params.Description),
	})
	if err != nil {
		return nil, fmt.Errorf("create Directus file record: %w", err)
	}
	return &File{
		ID:          fileID.String(),
		Storage:     "s3",
		FilePath:    params.FileName,
		ContentType: params.ContentType,
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
