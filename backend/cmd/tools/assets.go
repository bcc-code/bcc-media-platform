package main

import (
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"time"
)

// DeleteUnusedAssets exports paths of unused assets.
func DeleteUnusedAssets(queries *sqlc.Queries, awsProfile string) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		assets, err := queries.ListAssets(ctx)
		if err != nil {
			log.L.Error().Err(err).Send()
			ctx.Status(500)
			return
		}

		episodes, err := queries.ListEpisodes(ctx)
		if err != nil {
			log.L.Error().Err(err).Send()
			ctx.Status(500)
			return
		}

		var usedIDs []int32
		var paths []string

		for _, e := range episodes {
			if e.AssetID.Valid {
				a, found := lo.Find(assets, func(a sqlc.Asset) bool {
					return a.ID == int32(e.AssetID.Int64)
				})
				if found {
					if a.EncodingVersion.String == "azure_media_services" || a.DateCreated.After(time.Now().Add(time.Hour*24*7*-1)) {
						continue
					}
					usedIDs = append(usedIDs, a.ID)
					if a.MainStoragePath.Valid {
						paths = append(paths, a.MainStoragePath.String)
					}
				}
			}
		}

		var unusedIDs []int32
		var unusedPaths []string

		for _, a := range assets {
			if a.EncodingVersion.String == "azure_media_services" || a.DateCreated.After(time.Now().Add(time.Hour*24*7*-1)) {
				continue
			}
			if !lo.Contains(usedIDs, a.ID) {
				unusedIDs = append(unusedIDs, a.ID)
			}
			if a.MainStoragePath.Valid && !lo.Contains(paths, a.MainStoragePath.String) {
				unusedPaths = append(unusedPaths, a.MainStoragePath.String)
			}
		}

		cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion("eu-north-1"), config.WithSharedConfigProfile(awsProfile))
		if err != nil {
			log.L.Error().Err(err).Send()
			return
		}

		service := s3.NewFromConfig(cfg)

		bucket := "vod-asset-storage-prod"

		i := 0

		for _, path := range unusedPaths {
			if i >= 200 {
				break
			}
			i++
			objs, err := service.ListObjects(ctx, &s3.ListObjectsInput{
				Bucket: &bucket,
				Prefix: &path,
			})
			if err != nil {
				log.L.Error().Err(err).Send()
				return
			}
			for _, obj := range objs.Contents {
				log.L.Debug().Str("key", *obj.Key).Msg("Deleting blob")
				_, err := service.DeleteObject(ctx, &s3.DeleteObjectInput{
					Bucket: &bucket,
					Key:    obj.Key,
				})
				if err != nil {
					log.L.Error().Err(err).Send()
					return
				}
			}
			log.L.Debug().Str("path", path).Msg("Deleting asset from db")
			err = queries.DeletePath(ctx, null.StringFrom(path))
			if err != nil {
				log.L.Error().Err(err).Send()
				return
			}
		}

		ctx.JSON(200, map[string]any{
			"paths":            paths,
			"pathsCount":       len(paths),
			"usedIds":          usedIDs,
			"usedIdsCount":     len(usedIDs),
			"unusedIds":        unusedIDs,
			"unusedIdsCount":   len(unusedIDs),
			"unusedPaths":      unusedPaths,
			"unusedPathsCount": len(unusedPaths),
		})
	}
}
