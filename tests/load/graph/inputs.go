package graph

import _ "embed"

type input struct {
	query     string
	variables map[string]any
}

//go:embed queries/page.graphql
var pageQuery string
var pageInput = input{
	query: pageQuery,
	variables: map[string]any{
		"code": "frontpage",
	},
}

func getInputs() []input {
	return []input{
		pageInput,
	}
}
