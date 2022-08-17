package jsonlogic

import (
	"encoding/json"
	"fmt"
	"github.com/stretchr/testify/assert"
	"io/ioutil"
	"os"
	"testing"
)

type filter struct {
	In  map[string]any `json:"in"`
	Out string         `json:"out"`
}

func TestConvertToSQL(t *testing.T) {
	files, _ := os.ReadDir("./testdata")
	for _, fileName := range files {
		jsonFile, err := os.Open("./testdata/" + fileName.Name())
		if err != nil {
			fmt.Println(err)
			return
		}

		fmt.Println("Successfully opened " + fileName.Name())

		byteValue, _ := ioutil.ReadAll(jsonFile)

		var f filter
		err = json.Unmarshal(byteValue, &f)
		assert.NoError(t, err)

		filterString := GetSQLQueryFromFilter(f.In)
		assert.Equal(t, f.Out, filterString)
	}
}
