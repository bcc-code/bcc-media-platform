package asset

import (
	"context"
	"errors"
	"fmt"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/bcc-code/mediabank-bridge/log"
	"go.opentelemetry.io/otel"
)

// constant for number of bits in 2 gigabytes
const maxPartSize = 2 * 1024 * 1024 * 1024

// getFileSize retrieves the size of a file in bytes from S3
func getFileSize(ctx context.Context, svc s3.Client, bucketName, objectKey *string) (int64, error) {
	input := &s3.HeadObjectInput{
		Bucket: bucketName,
		Key:    objectKey,
	}

	result, err := svc.HeadObject(ctx, input)
	if err != nil {
		return 0, err
	}

	return result.ContentLength, nil
}

func copyObjects(
	ctx context.Context,
	s3client s3.Client,
	sourceBucket *string,
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

			err := multiPartCopy(ctx, s3client, sourceBucket, f)
			if err != nil {
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

// helper function to build the string for the range of bits to copy
func buildCopySourceRange(start int64, objectSize int64) string {
	end := start + maxPartSize - 1
	if end > objectSize {
		end = objectSize - 1
	}
	startRange := strconv.FormatInt(start, 10)
	stopRange := strconv.FormatInt(end, 10)
	return "bytes=" + startRange + "-" + stopRange
}

// multiPartCopy copies a file from one bucket to another using multipart upload
// this is needed for files larger than 5GB
//
// The rough steps are:
// 1. Get the size of the file
// 2. Start a multipart upload
// 3. Upload each part of the file in a loop
// 4. Complete the upload
func multiPartCopy(ctx context.Context, svc s3.Client, sourceBucket *string, copyInput *s3.CopyObjectInput) error {
	log := log.L

	ctx, cancelFn := context.WithTimeout(ctx, 10*time.Minute)
	defer cancelFn()

	sourceKey := strings.Replace(*copyInput.CopySource, *sourceBucket+"/", "", 1)

	// 1. Get the size of the file
	fileSize, err := getFileSize(ctx, svc, sourceBucket, &sourceKey)
	if err != nil {
		log.Error().
			Err(err).
			Str("bucket", *copyInput.Bucket).
			Str("source path", sourceKey).
			Str("dst path", *copyInput.Key).
			Msg("Getting file size failed")

		return merry.Wrap(err)
	}

	//struct for starting a multipart upload
	startInput := s3.CreateMultipartUploadInput{
		Bucket: copyInput.Bucket,
		Key:    copyInput.Key,
	}

	var uploadId string
	// 2. Start a multipart upload
	createOutput, err := svc.CreateMultipartUpload(ctx, &startInput)
	if err != nil {
		return err
	}
	if createOutput != nil {
		if createOutput.UploadId != nil {
			uploadId = *createOutput.UploadId
		}
	}
	if uploadId == "" {
		return errors.New("No upload id found in start upload request")
	}

	var i int64
	var partNumber int32 = 1
	parts := []types.CompletedPart{}

	numUploads := fileSize / maxPartSize

	// 3. Upload each part of the file in a loop
	log.Info().Int64("fileSize", fileSize).Int64("numUploads", numUploads).Msg("Starting multipart upload")
	for i = 0; i < fileSize; i += maxPartSize {
		copyRange := buildCopySourceRange(i, fileSize)
		partInput := s3.UploadPartCopyInput{
			Bucket:          copyInput.Bucket,
			CopySource:      copyInput.CopySource,
			CopySourceRange: &copyRange,
			Key:             copyInput.Key,
			PartNumber:      partNumber,
			UploadId:        &uploadId,
		}

		log.Debug().Int32("partNumber", partNumber).Str("copyRange", copyRange).Int64("i", i).Msg("Starting part upload")
		partResp, err := svc.UploadPartCopy(ctx, &partInput)

		if err != nil {
			log.Error().Msg("Attempting to abort upload")
			abortIn := s3.AbortMultipartUploadInput{
				UploadId: &uploadId,
			}

			//ignoring any errors with aborting the copy
			_, _ = svc.AbortMultipartUpload(ctx, &abortIn)
			return fmt.Errorf("Error uploading part %d : %w", partNumber, err)
		}

		//copy etag and part number from response as it is needed for completion
		if partResp != nil {
			partNum := partNumber
			etag := strings.Trim(*partResp.CopyPartResult.ETag, "\"")
			cPart := types.CompletedPart{
				ETag:       &etag,
				PartNumber: partNum,
			}
			parts = append(parts, cPart)
			log.Debug().Msgf("Successfully upload part %d of %s", partNumber, uploadId)
		}
		partNumber++
		if partNumber%50 == 0 {
			log.Info().Msgf("Completed part %d of %d to %s", partNumber, numUploads, *copyInput.Key)
		}
	}

	//create struct for completing the upload
	mpu := types.CompletedMultipartUpload{
		Parts: parts,
	}

	// 4. Complete the upload
	complete := s3.CompleteMultipartUploadInput{
		Bucket:          copyInput.Bucket,
		Key:             copyInput.Key,
		UploadId:        &uploadId,
		MultipartUpload: &mpu,
	}

	compOutput, err := svc.CompleteMultipartUpload(ctx, &complete)
	if err != nil {
		return fmt.Errorf("Error completing upload: %w", err)
	}

	if compOutput != nil {
		log.Info().Msgf("Successfully copied source: %s to Bucket: %s Key: %s", *copyInput.CopySource, *copyInput.Bucket, *copyInput.Key)
	}

	return nil
}
