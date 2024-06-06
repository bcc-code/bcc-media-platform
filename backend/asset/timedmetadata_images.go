package asset

import (
	"context"
	"fmt"
	"path"
	"sync"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/files"
	"github.com/bcc-code/bcc-media-platform/backend/imagor"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"golang.org/x/sync/errgroup"
)

// ingestImagesFromS3 downloads images from S3 and uploads them to the platform
func ingestImagesFromS3(ctx context.Context, imagePaths []string, services externalServices, config config) (map[string]string, error) {
	s3client := services.GetS3Client()

	var eg errgroup.Group
	imageIDs := make(map[string]string)
	var mu sync.Mutex
	for _, image := range imagePaths {
		i := image
		eg.Go(func() error {
			file, err := readFromS3(ctx, readFromS3Params{
				client: s3client,
				bucket: config.GetIngestBucket(),
				path:   i,
			})
			if err != nil {
				return merry.Wrap(err)
			}
			defer file.Close()

			fs := services.GetFileService()
			f, err := fs.UploadFile(ctx, files.UploadFileParams{
				File:     file,
				FileName: path.Base(i),
			})
			if err != nil {
				return merry.Wrap(err)
			}
			mu.Lock()
			imageIDs[i] = f.ID
			mu.Unlock()
			return nil
		})
	}
	if err := eg.Wait(); err != nil {
		log.L.Error().Err(err).Msg("Error uploading image")
		return nil, merry.Wrap(err)
	}
	return imageIDs, nil
}

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
	uuid, err := uuid.NewV7()
	if err != nil {
		return nil, merry.Wrap(err)
	}
	filename := fmt.Sprintf("image-%d-%f-%s.jpg", assetID, timestamp, uuid.String())
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
