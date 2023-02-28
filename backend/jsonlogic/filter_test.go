package jsonlogic

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"testing"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
)

type filter struct {
	In   map[string]any `json:"in"`
	Out  string         `json:"out"`
	Args []interface{}  `json:"args"`
}

func TestConvertToSQL(t *testing.T) {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	files, _ := os.ReadDir("./testdata")
	for _, fileName := range files {
		jsonFile, err := os.Open("./testdata/" + fileName.Name())
		if err != nil {
			fmt.Println(err)
			return
		}

		fmt.Println("Successfully opened " + fileName.Name())

		byteValue, _ := io.ReadAll(jsonFile)

		var f filter
		err = json.Unmarshal(byteValue, &f)
		assert.NoError(t, err)

		filterString := GetSQLQueryFromFilter(f.In)
		sql, args, err := filterString.Filter.ToSql()
		assert.NoError(t, err)
		assert.Equal(t, f.Out, sql)
		assert.Equal(t, f.Args, args)
	}
}
