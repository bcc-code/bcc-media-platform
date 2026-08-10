package version

import (
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/graph/public/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/gin-gonic/gin"
	"net/http"
	"os"
	"path"
	"path/filepath"
)

var version = &model.Version{}

// We find the first `version.json` based on the current CWD and working towards the root.
func init() {
	pwd, err := os.Getwd()
	if err != nil {
		return
	}

	root := "/"
	// This should prevent infinite loops on windows especially!
	// Not tested
	if filepath.VolumeName(pwd) != "" {
		root = filepath.VolumeName(pwd)
	}

	for pwd != root {
		jsonPath := path.Join(pwd, "version.json")
		pwd = path.Clean(path.Join(pwd, ".."))

		// File not present, descend
		if _, err := os.Stat(jsonPath); err != nil {
			continue
		}

		jsonBytes, err := os.ReadFile(jsonPath)
		if err != nil {
			return
		}

		if err := json.Unmarshal(jsonBytes, version); err != nil {
			log.L.Warn().Err(err).Str("path", jsonPath).Msg("Failed to parse version.json")
		}
		return
	}
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
