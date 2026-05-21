// Package extension contains gqlgen handler extensions used by the API.
package extension

import (
	"context"
	"errors"

	"github.com/99designs/gqlgen/graphql"
	"github.com/vektah/gqlparser/v2/ast"
	"github.com/vektah/gqlparser/v2/gqlerror"
)

// DepthLimit rejects operations whose selection set nests deeper than Max.
// Fragment spreads and inline fragments are followed but do not themselves
// count as a depth level — only field selections do, matching how a server
// actually expands work.
type DepthLimit struct {
	Max int
}

var _ interface {
	graphql.OperationContextMutator
	graphql.HandlerExtension
} = DepthLimit{}

func (DepthLimit) ExtensionName() string { return "DepthLimit" }

func (d DepthLimit) Validate(graphql.ExecutableSchema) error {
	if d.Max <= 0 {
		return errors.New("DepthLimit.Max must be > 0")
	}
	return nil
}

func (d DepthLimit) MutateOperationContext(_ context.Context, opCtx *graphql.OperationContext) *gqlerror.Error {
	if opCtx == nil || opCtx.Operation == nil {
		return nil
	}
	fragments := map[string]*ast.FragmentDefinition{}
	if opCtx.Doc != nil {
		for _, f := range opCtx.Doc.Fragments {
			fragments[f.Name] = f
		}
	}
	depth := maxSelectionDepth(opCtx.Operation.SelectionSet, 1, fragments)
	if depth > d.Max {
		return gqlerror.Errorf("operation exceeds maximum depth of %d (got %d)", d.Max, depth)
	}
	return nil
}

func maxSelectionDepth(sel ast.SelectionSet, depth int, fragments map[string]*ast.FragmentDefinition) int {
	best := depth
	for _, s := range sel {
		switch v := s.(type) {
		case *ast.Field:
			if len(v.SelectionSet) > 0 {
				if c := maxSelectionDepth(v.SelectionSet, depth+1, fragments); c > best {
					best = c
				}
			}
		case *ast.InlineFragment:
			if c := maxSelectionDepth(v.SelectionSet, depth, fragments); c > best {
				best = c
			}
		case *ast.FragmentSpread:
			if f, ok := fragments[v.Name]; ok {
				if c := maxSelectionDepth(f.SelectionSet, depth, fragments); c > best {
					best = c
				}
			}
		}
	}
	return best
}
