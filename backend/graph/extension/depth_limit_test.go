package extension

import (
	"context"
	"testing"

	"github.com/99designs/gqlgen/graphql"
	"github.com/stretchr/testify/assert"
	"github.com/vektah/gqlparser/v2/ast"
	"github.com/vektah/gqlparser/v2/parser"
)

func parseOp(t *testing.T, src string) *graphql.OperationContext {
	t.Helper()
	doc, perr := parser.ParseQuery(&ast.Source{Input: src})
	if perr != nil {
		t.Fatalf("parse: %v", perr)
	}
	if len(doc.Operations) == 0 {
		t.Fatalf("no operations")
	}
	return &graphql.OperationContext{
		Doc:       doc,
		Operation: doc.Operations[0],
	}
}

func TestDepthLimit_AllowsUnderLimit(t *testing.T) {
	opCtx := parseOp(t, `{ a { b { c } } }`) // depth 3
	err := DepthLimit{Max: 3}.MutateOperationContext(context.Background(), opCtx)
	assert.Nil(t, err)
}

func TestDepthLimit_RejectsOverLimit(t *testing.T) {
	opCtx := parseOp(t, `{ a { b { c { d } } } }`) // depth 4
	err := DepthLimit{Max: 3}.MutateOperationContext(context.Background(), opCtx)
	assert.NotNil(t, err)
	assert.Contains(t, err.Message, "exceeds maximum depth")
}

func TestDepthLimit_CountsThroughFragmentSpread(t *testing.T) {
	// Total nesting is 4 (a > b > c > d) even though spread out across fragments.
	opCtx := parseOp(t, `
		{ a { b { ...F } } }
		fragment F on T { c { d } }
	`)
	err := DepthLimit{Max: 3}.MutateOperationContext(context.Background(), opCtx)
	assert.NotNil(t, err)
}

func TestDepthLimit_CountsThroughInlineFragment(t *testing.T) {
	// Inline fragments must not be a free pass past the limit.
	opCtx := parseOp(t, `{ a { ... on T { b { c { d } } } } }`) // depth 4
	err := DepthLimit{Max: 3}.MutateOperationContext(context.Background(), opCtx)
	assert.NotNil(t, err)
}

func TestDepthLimit_Validate(t *testing.T) {
	assert.Error(t, DepthLimit{Max: 0}.Validate(nil))
	assert.Error(t, DepthLimit{Max: -1}.Validate(nil))
	assert.NoError(t, DepthLimit{Max: 1}.Validate(nil))
}
