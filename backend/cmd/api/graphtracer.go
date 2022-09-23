package main

import (
	"context"
	"github.com/99designs/gqlgen/graphql"
	"go.opentelemetry.io/otel"
)

type graphTracer struct {
}

// ExtensionName name of extension
func (t *graphTracer) ExtensionName() string {
	return "GraphTracer"
}

// InterceptField intercepts
func (t *graphTracer) InterceptField(ctx context.Context, next graphql.Resolver) (any, error) {
	ctx, span := otel.Tracer("graph").Start(ctx, "field")
	defer span.End()
	return next(ctx)
}

// InterceptOperation intercepts
func (t *graphTracer) InterceptOperation(ctx context.Context, next graphql.OperationHandler) graphql.ResponseHandler {
	ctx, span := otel.Tracer("graph").Start(ctx, "operation")
	defer span.End()
	return next(ctx)
}

// Validate is unnecessary in our case
func (t *graphTracer) Validate(_ graphql.ExecutableSchema) error {
	return nil
}
