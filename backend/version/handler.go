package version

import (
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/graph/public/model"
	"github.com/davecgh/go-spew/spew"
	"github.com/gin-gonic/gin"
	"net/http"
	"os"
	"path"
	"path/filepath"
)

var versionJson = []byte("{}")
var versionObj *model.Version

// We find the first `version.json` based on the current CWD and working towards the root.
func init() {
	pwd, err := os.Getwd()
	if err != nil {
		versionJson = []byte(err.Error())
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

		if _, err := os.Stat(jsonPath); err == nil {
			jsonBytes, err := os.ReadFile(jsonPath)
			if err != nil {
				versionJson = []byte(err.Error())
			} else {
				versionJson = jsonBytes
			}
			return
		}

		pwd = path.Join(pwd, "..")
		pwd = path.Clean(pwd)
		println(pwd)
	}
}

// GinHandler returns a json string with the version data
func GinHandler(ctx *gin.Context) {
	ctx.Data(http.StatusOK, "application/json", versionJson)
	return
}

// GQLHandler returns a GQL formatted version object
func GQLHandler() (*model.Version, error) {
	// Only do this once and only if needed
	if versionObj == nil {
		versionObj = &model.Version{}
		err := json.Unmarshal(versionJson, versionObj)
		if err != nil {
			spew.Dump(err)
			return nil, err
		}
	}

	return versionObj, nil
}
