package jsonlogic

import (
	"encoding/json"
	"fmt"
	"github.com/stretchr/testify/assert"
	"io/ioutil"
	"os"
	"testing"
)

func TestConvertToSQL(t *testing.T) {
	// Open our jsonFile
	jsonFile, err := os.Open("./testdata/filter.json")
	// if we os.Open returns an error then handle it
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("Successfully Opened filter.json")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)

	var filter map[string]any
	err = json.Unmarshal(byteValue, &filter)
	assert.NoError(t, err)

	filterString := GetSQLStringFromFilter(filter)
	assert.Equal(t, filterString, "(available_to > '2022-02-10') AND ((id = 10) OR ('true' = 'true'))")
}

func TestInjectionFails(t *testing.T) {
	// Open our jsonFile
	jsonFile, err := os.Open("./testdata/malfilter.json")
	// if we os.Open returns an error then handle it
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("Successfully Opened filter.json")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)

	var filter map[string]any
	err = json.Unmarshal(byteValue, &filter)
	assert.NoError(t, err)

	filterString := GetSQLStringFromFilter(filter)
	assert.Equal(t, filterString, "(1 = 0) AND ((id = 10) OR ('true' = 'true'))")
}
