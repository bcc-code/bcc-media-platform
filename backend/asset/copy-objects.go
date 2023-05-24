package asset

import (
	"context"
	"sync"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go/aws/awserr"
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

			tries := 1
			for tries <= 3 {
				_, err := s3client.CopyObject(ctx, f)

				if err == nil {
					break
				}

				// We have an error
				if awsErr, ok := err.(awserr.Error); ok && awsErr.Code() != "NoSuchKey" {
					log.L.Warn().
						Err(err).
						Str("dst bucket", *f.Bucket).
						Str("source path", *f.CopySource).
						Str("dst path", *f.Key).
						Int("tries", tries).
						Msg("File copy failed due to missing file")

					// For some reason the system notifies us before the files are available
					// so we wait a bit and try again
					// This should be removed once https://www.notion.so/bccmedia/Export-Asset-for-Downloading-6a82bb779dd4474d910c53d36551f05f?pvs=4#eab1f760803a4b8dbf3bad487549d9a2 has been fixed
					time.Sleep(60 * time.Second)
					tries += 1
					continue
				}

				log.L.Error().
					Err(err).
					Str("dst bucket", *f.Bucket).
					Str("source path", *f.CopySource).
					Str("dst path", *f.Key).
					Msg("File copy failed")

				copyErrors = append(copyErrors, merry.Wrap(err))

				// We have an error that we can't handle so just return from the function
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
