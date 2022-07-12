package smil

import (
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"strings"
	"testing"

	"github.com/davecgh/go-spew/spew"
	"github.com/stretchr/testify/assert"
)

func TestUnmarshall(t *testing.T) {
	files, _ := os.ReadDir("./testdata")
	spew.Dump(files)

	for _, file := range files {
		fileName := path.Join("./testdata", file.Name())
		if !strings.HasSuffix(fileName, ".xml") {
			continue
		}

		// Open our xmlFile
		xmlFile, err := os.Open(fileName)
		// if we os.Open returns an error then handle it
		if err != nil {
			fmt.Println(err)
		}

		fmt.Println("Successfully Opened users.xml")
		// defer the closing of our xmlFile so that we can parse it later on
		defer xmlFile.Close()

		byteValue, _ := ioutil.ReadAll(xmlFile)

		_, err = Unmarshall(byteValue)
		assert.NoError(t, err)
	}

}
