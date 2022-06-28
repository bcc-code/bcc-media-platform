package asset

import (
	"context"
	"sync"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/mediabank-bridge/log"
	"go.opentelemetry.io/otel"
)

func copyObjects(
	ctx context.Context,
	s3client s3.Client,
	filesToCopy map[string]*s3.CopyObjectInput,
) []error {
	tracer := otel.Tracer("asset")
	ctx, span := tracer.Start(ctx, "copyObjects")
	defer span.End()

	copyErrors := []error{}
	var wg sync.WaitGroup

	wg.Add(len(filesToCopy))
	for _, file := range filesToCopy {
		f := file
		go func() {
			defer wg.Done()
			ctx, span := tracer.Start(ctx, "copyObject")
			defer span.End()

			_, err := s3client.CopyObject(ctx, f)

			if err != nil {
				log.L.Error().
					Err(err).
					Str("dst bucket", *f.Bucket).
					Str("source path", *f.CopySource).
					Str("dst path", *f.Key).
					Msg("File copy failed")

				copyErrors = append(copyErrors, merry.Wrap(err))
				return
			}
			log.L.Info().
				Str("dst bucket", *f.Bucket).
				Str("source path", *f.CopySource).
				Str("dst path", *f.Key).
				Msg("File copied")
		}()
	}
	wg.Wait()
	return copyErrors
}
