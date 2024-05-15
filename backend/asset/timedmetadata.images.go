package asset

import (
	"context"
	"os"
	"path"
	"sync"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/files"
	"github.com/bcc-code/mediabank-bridge/log"
	"golang.org/x/sync/errgroup"
)

// ingestImagesFromS3 downloads images from S3 and uploads them to the platform
func ingestImagesFromS3(ctx context.Context, imagePaths []string, services externalServices, config config) (map[string]string, error) {
	s3client := services.GetS3Client()
	tempDir, err := os.MkdirTemp(config.GetTempDir(), "timedmetadata")
	if err != nil {
		return nil, merry.Wrap(err)
	}
	defer os.RemoveAll(tempDir)

	var eg errgroup.Group
	imageIDs := make(map[string]string)
	var mu sync.Mutex
	for _, image := range imagePaths {
		i := image
		eg.Go(func() error {
			localPath := path.Join(tempDir, i)
			_, err := downloadFromS3(ctx, downloadFromS3Params{
				client:    s3client,
				bucket:    config.GetIngestBucket(),
				path:      i,
				localPath: localPath,
			})
			if err != nil {
				return merry.Wrap(err)
			}

			imageId, err := uploadFileToPlatform(ctx, services, localPath)
			if err != nil {
				return merry.Wrap(err)
			}
			mu.Lock()
			imageIDs[i] = *imageId
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

// uploadFileToPlatform uploads a file to the platform
func uploadFileToPlatform(ctx context.Context, services externalServices, localPath string) (*string, error) {
	fs := services.GetFileService()
	file, err := os.Open(localPath)
	if err != nil {
		return nil, merry.Wrap(err)
	}
	defer file.Close()

	f, err := fs.UploadFile(ctx, files.UploadFileParams{
		File:     file,
		FileName: path.Base(localPath),
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}

	return &f.ID, nil
}
