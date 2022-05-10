package smil

import (
	"fmt"
	"io/ioutil"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestUnmarshall(t *testing.T) {

	fileList := []string{
		"smil.xml",
	}

	for _, fileName := range fileList {
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
