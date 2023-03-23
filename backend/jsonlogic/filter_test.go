package jsonlogic

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"strings"
	"testing"

	"github.com/Masterminds/squirrel"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lib/pq"
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

func TestRelativeOrFalse(t *testing.T) {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	testTable := []struct {
		Operator string
		Property string
		Value    any
		Expected squirrel.Sqlizer
		Ok       bool
	}{
		{
			Operator: ">",
			Property: "property",
			Value:    "relative:1 day",
			Expected: squirrel.Expr(fmt.Sprintf("%s %s (NOW() + interval %s)", "property", ">", pq.QuoteLiteral(strings.Replace("relative:1 day", "relative:", "", 1)))),
			Ok:       true,
		},
		{
			Operator: ">",
			Property: "property",
			Value:    "relativeneg:1 day",
			Expected: squirrel.Expr(fmt.Sprintf("%s %s (NOW() - interval %s)", "property", ">", pq.QuoteLiteral(strings.Replace("relativeneg:1 day", "relativeneg:", "", 1)))),
			Ok:       true,
		},
		{
			Operator: ">",
			Property: "property",
			Value:    "1 day",
			Expected: squirrel.Eq{
				"1": "0",
			},
			Ok: false,
		},
	}

	for _, tt := range testTable {
		actual, ok := relativeOrFalse(tt.Operator, tt.Property, tt.Value)
		assert.Equal(t, tt.Ok, ok)
		assert.Equal(t, tt.Expected, actual)
	}
}
