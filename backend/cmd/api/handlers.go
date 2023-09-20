package main

import (
	"context"
	"database/sql"
	"github.com/99designs/gqlgen/graphql"
	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/analytics"
	"github.com/bcc-code/bcc-media-platform/backend/auth0"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/email"
	graphadmin "github.com/bcc-code/bcc-media-platform/backend/graph/admin"
	graphadmingenerated "github.com/bcc-code/bcc-media-platform/backend/graph/admin/generated"
	graphapi "github.com/bcc-code/bcc-media-platform/backend/graph/api"
	graphapigenerated "github.com/bcc-code/bcc-media-platform/backend/graph/api/generated"
	"github.com/bcc-code/bcc-media-platform/backend/graph/gqltracer"
	graphpublic "github.com/bcc-code/bcc-media-platform/backend/graph/public"
	graphpublicgenerated "github.com/bcc-code/bcc-media-platform/backend/graph/public/generated"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/gin-gonic/gin"
	"github.com/vektah/gqlparser/v2/gqlerror"
)

// Defining the Graphql handler
func graphqlHandler(
	db *sql.DB,
	queries *sqlc.Queries,
	loaders *common.BatchLoaders,
	searchService *search.Service,
	emailService *email.Service,
	urlSigner *signing.Signer,
	config envConfig,
	s3client *s3.Client,
	analyticsSalt string,
	authClient *auth0.Client,
	remoteCache *remotecache.Client,
) gin.HandlerFunc {
	resolver := graphapi.Resolver{
		Queries:         queries,
		Loaders:         loaders,
		FilteredLoaders: filteredLoaderFactory(db, queries, loaders.CollectionLoader),
		ProfileLoaders:  profileLoaderFactory(queries),
		SearchService:   searchService,
		EmailService:    emailService,
		URLSigner:       urlSigner,
		S3Client:        s3client,
		APIConfig:       config.CDNConfig,
		AWSConfig:       config.AWS,
		RedirectConfig:  config.Redirect,
		AuthClient:      authClient,
		RemoteCache:     remoteCache,
		AnalyticsIDFactory: func(ctx context.Context) string {
			ginCtx, err := utils.GinCtx(ctx)
			p := user.GetProfileFromCtx(ginCtx)
			if err != nil || p == nil {
				return "anonymous"
			}
			u := user.GetFromCtx(ginCtx)

			aID := analytics.GenerateID(p.ID, analyticsSalt)
			if u.IsActiveBCC() {
				return aID
			}
			return "ext-" + aID
		},
	}

	tracer := &gqltracer.GraphTracer{}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphapigenerated.NewExecutableSchema(graphapigenerated.Config{Resolvers: &resolver}))
	h.Use(tracer)
	h.SetErrorPresenter(func(ctx context.Context, err error) *gqlerror.Error {
		gqlError := graphql.DefaultErrorPresenter(ctx, err)
		if code := merry.Value(err, "code"); code != nil {
			if gqlError.Extensions == nil {
				gqlError.Extensions = map[string]any{}
			}
			gqlError.Extensions["code"] = code
		}
		if userMessage := merry.UserMessage(err); userMessage != "" {
			log.L.Warn().Err(gqlError).Msg("GraphQL exception: " + userMessage)
			gqlError.Message = userMessage
		} else {
			if _, ok := err.(*gqlerror.Error); ok {
				return gqlError
			}
			log.L.Error().Err(err).Send()
			gqlError.Message = "error occurred"
		}
		return gqlError
	})

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func publicGraphqlHandler(loaders *common.BatchLoaders) gin.HandlerFunc {
	resolver := graphpublic.Resolver{
		Loaders: &graphpublic.Loaders{
			EpisodeLoader: loaders.EpisodeLoader,
			SeasonLoader:  loaders.SeasonLoader,
			ShowLoader:    loaders.ShowLoader,
		},
	}

	tracer := &gqltracer.GraphTracer{}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphpublicgenerated.NewExecutableSchema(graphpublicgenerated.Config{Resolvers: &resolver}))
	h.Use(tracer)

	return func(c *gin.Context) {
		h.ServeHTTP(c.Writer, c.Request)
	}
}

func adminGraphqlHandler(config envConfig, db *sql.DB, queries *sqlc.Queries, loaders *common.BatchLoaders) gin.HandlerFunc {
	resolver := graphadmin.Resolver{
		DB:      db,
		Queries: queries,
		Loaders: loaders,
	}

	// NewExecutableSchema and Config are in the generated.go file
	// Resolver is in the resolver.go file
	h := handler.NewDefaultServer(graphadmingenerated.NewExecutableSchema(graphadmingenerated.Config{Resolvers: &resolver}))

	directusSecret := config.Secrets.Directus
	if directusSecret == "" {
		log.L.Debug().Msg("No secret for Directus found in environment. Disabling endpoint")
		return func(c *gin.Context) {
			c.AbortWithStatus(404)
			return
		}
	}

	return func(c *gin.Context) {
		headerValue := c.GetHeader("x-api-key")
		if headerValue != directusSecret {
			c.AbortWithStatus(403)
			return
		}

		h.ServeHTTP(c.Writer, c.Request)
	}
}
