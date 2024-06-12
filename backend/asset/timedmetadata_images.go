package asset

import (
	"context"
	"fmt"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/files"
	"github.com/bcc-code/bcc-media-platform/backend/videomanipulator"
	"github.com/google/uuid"
	"go.opentelemetry.io/otel"
)

func generateImageForAssetAtTime(ctx context.Context, services externalServices, config config, assetID int32, timestamp float64) (*string, error) {
	ctx, span := otel.Tracer("timedmetadata").Start(ctx, "generateImageForAssetAtTime")
	defer span.End()

	u, err := getSignedAudiolessVideoURLForAssetID(ctx, services, config, assetID)
	if err != nil {
		return nil, merry.Wrap(err)
	}
	span.AddEvent("got video url")

	videoManipulator := services.GetVideoManipulatorService()
	image, err := videoManipulator.GenerateImageForUrl(videomanipulator.GenerateImageForUrlParams{
		VideoUrl: *u,
		Seconds:  timestamp,
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}
	defer image.Reader.Close()
	span.AddEvent("generated image for video")

	fs := services.GetFileService()
	title := fmt.Sprintf("Asset %d@%.1fs", assetID, timestamp)
	hms := secondsToHMS(timestamp)
	description := fmt.Sprintf("Image for asset %d at %.2fs (%s)", assetID, timestamp, hms)
	f, err := fs.UploadFile(ctx, files.UploadFileParams{
		File:        image.Reader,
		FileName:    fmt.Sprintf("image-%d-%f-%s.jpg", assetID, timestamp, uuid.NewString()),
		ContentType: image.ContentType,
		Title:       &title,
		Description: &description,
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}
	span.AddEvent("uploaded image")

	return &f.ID, nil

}

func secondsToHMS(seconds float64) string {
	return fmt.Sprintf("%02d:%02d:%02d", int(seconds/3600), int(seconds/60)%60, int(seconds)%60)
}
