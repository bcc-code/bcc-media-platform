package search

import (
	"bytes"
	"encoding/json"
	"html/template"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func renderAdmin(t *testing.T, query string, filter AdminFilter) map[string]any {
	t.Helper()
	raw, err := renderAdminQuery(query, filter, 20, 40, []string{"no", "en"}, 1234)
	require.NoError(t, err)
	var out map[string]any
	require.NoError(t, json.Unmarshal(raw, &out), string(raw))
	return out
}

func Test_mainElasticTemplate_golden(t *testing.T) {
	params := &elasticQueryParams{Roles: []string{"bcc-members", "public"}, QueryString: template.HTML("te\\\"st"), Limit: 10, Offset: 5, TimeNow: 1234, Languages: []string{"no", "en"}, AuxLanguages: []string{"no", "de", "en"}}
	buf := &bytes.Buffer{}
	require.NoError(t, templates.ExecuteTemplate(buf, "main-elastic.json.tmpl", params))

	golden, err := os.ReadFile("testdata/main-elastic.golden.json")
	require.NoError(t, err)
	assert.JSONEq(t, string(golden), buf.String())
}

func Test_adminQuery_noGroup(t *testing.T) {
	q := renderAdmin(t, "test", AdminFilter{})
	b := q["query"].(map[string]any)["bool"].(map[string]any)

	assert.Empty(t, b["filter"])
	assert.NotEmpty(t, b["should"])
	assert.EqualValues(t, 3, q["min_score"])
	assert.EqualValues(t, 40, q["from"])
	assert.EqualValues(t, 20, q["size"])
}

func Test_adminQuery_group(t *testing.T) {
	group := "bcc-members"
	q := renderAdmin(t, "test", AdminFilter{Group: &group})
	filters := q["query"].(map[string]any)["bool"].(map[string]any)["filter"]

	expected, err := json.Marshal(visibilityClauses([]string{group}, 1234))
	require.NoError(t, err)
	actual, err := json.Marshal(filters)
	require.NoError(t, err)
	assert.JSONEq(t, string(expected), string(actual))

	// Must match the filters the public search applies for the same role.
	params := &elasticQueryParams{Roles: []string{group}, QueryString: "test", Limit: 1, TimeNow: 1234, Languages: []string{"no"}, AuxLanguages: []string{"en"}}
	buf := &bytes.Buffer{}
	require.NoError(t, templates.ExecuteTemplate(buf, "main-elastic.json.tmpl", params))
	var main map[string]any
	require.NoError(t, json.Unmarshal(buf.Bytes(), &main))
	mainFilters, err := json.Marshal(main["query"].(map[string]any)["bool"].(map[string]any)["filter"])
	require.NoError(t, err)
	assert.JSONEq(t, string(mainFilters), string(actual))
}

func Test_adminQuery_emptyQuery(t *testing.T) {
	q := renderAdmin(t, "", AdminFilter{})
	b := q["query"].(map[string]any)["bool"].(map[string]any)

	assert.NotContains(t, q, "min_score")
	assert.NotContains(t, b, "should")
}

func Test_adminQuery_escapes(t *testing.T) {
	renderAdmin(t, `a"b\c</script>`, AdminFilter{})
}

func Test_AdminFilter_indices(t *testing.T) {
	i, err := AdminFilter{}.indices()
	require.NoError(t, err)
	assert.Equal(t, "bccm-*", i)

	i, err = AdminFilter{Types: []string{"episode", "show", "episode"}}.indices()
	require.NoError(t, err)
	assert.Equal(t, "bccm-episodes,bccm-shows", i)

	_, err = AdminFilter{Types: []string{"any"}}.indices()
	assert.Error(t, err)
}
