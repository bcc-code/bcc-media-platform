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
		// Open our jsonFile
		jsonFile, err := os.Open("./testdata/" + fileName.Name())
		// if we os.Open returns an error then handle it
		if err != nil {
			fmt.Println(err)
		}

		fmt.Println("Successfully opened " + fileName.Name())
		// defer the closing of our jsonFile so that we can parse it later on
		defer jsonFile.Close()

		byteValue, _ := ioutil.ReadAll(jsonFile)

		var f filter
		err = json.Unmarshal(byteValue, &f)
		assert.NoError(t, err)

		filterString := GetSQLStringFromFilter(f.In)
		assert.Equal(t, f.Out, filterString)
	}

}
