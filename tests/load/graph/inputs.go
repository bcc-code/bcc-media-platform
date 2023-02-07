package graph

import _ "embed"

type input struct {
	name      string
	query     string
	variables map[string]any
}

//go:embed queries/page.graphql
var pageQuery string

func getInputs() []input {
	return []input{
		{
			name:  "page",
			query: pageQuery,
			variables: map[string]any{
				"code": "frontpage",
			},
		},
	}
}
