package version

import (
	"net/http"
	"runtime/debug"

	"github.com/bcc-code/bcc-media-platform/backend/graph/public/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/gin-gonic/gin"
)

var version = &model.Version{}

// The build sha is stamped into the binary by the go toolchain (-buildvcs), so it
// requires no files next to the binary and no knowledge of the working directory.
func init() {
	info, ok := debug.ReadBuildInfo()
	if !ok {
		log.L.Warn().Msg("No build info available, build_sha will be empty")
		return
	}

	sha := shaFromSettings(info.Settings)
	if sha == "" {
		log.L.Warn().Msg("Binary built without VCS stamping, build_sha will be empty")
		return
	}

	version.BuildSha = sha
}

// shaFromSettings extracts the short revision from the build settings, suffixed with
// `-dirty` if the working tree was modified at build time. Empty if not stamped.
func shaFromSettings(settings []debug.BuildSetting) string {
	var revision string
	var modified bool

	for _, s := range settings {
		switch s.Key {
		case "vcs.revision":
			revision = s.Value
		case "vcs.modified":
			modified = s.Value == "true"
		}
	}

	if revision == "" {
		return ""
	}

	// Matches the ${SEMAPHORE_GIT_SHA:0:7} tags the images are published under.
	if len(revision) > 7 {
		revision = revision[:7]
	}

	if modified {
		revision += "-dirty"
	}

	return revision
}

// GinHandler returns a json string with the version data
func GinHandler(ctx *gin.Context) {
	ctx.JSON(http.StatusOK, version)
	return
}

// GQLHandler returns a GQL formatted version object
func GQLHandler() (*model.Version, error) {
	return version, nil
}
