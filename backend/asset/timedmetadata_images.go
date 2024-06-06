package asset

import (
	"context"
	"fmt"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/files"
	"github.com/bcc-code/bcc-media-platform/backend/imagor"
	"github.com/google/uuid"
)

func generateImageForAssetAtTime(ctx context.Context, services externalServices, config config, assetID int32, timestamp float64) (*string, error) {
	u, err := getSignedAudiolessVideoURLForAssetID(ctx, services, config, assetID)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	imagorService := services.GetImagorService()

	image, err := imagorService.GenerateImageForUrl(imagor.GenerateImageForUrlParams{
		VideoUrl: *u,
		Seconds:  timestamp,
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}
	defer image.Close()

	fs := services.GetFileService()
	filename := fmt.Sprintf("image-%d-%f-%s.jpg", assetID, timestamp, uuid.NewString())
	f, err := fs.UploadFile(ctx, files.UploadFileParams{
		File:        image,
		FileName:    filename,
		ContentType: "image/jpeg",
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}

	return &f.ID, nil

}
