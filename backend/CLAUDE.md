# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the backend service for BrunstadTV, a media streaming platform. The backend is primarily written in Go and exposes GraphQL APIs for various client applications.

## Repository Structure

- `/cmd/api` - Main API service (GraphQL endpoints)
- `/cmd/jobs` - Background job processing service
- `/graph` - GraphQL schemas and resolvers
  - `/graph/api` - Main API schema
  - `/graph/admin` - Admin API schema
  - `/graph/public` - Public API schema
- `/sqlc` - Generated database access code
- `/search` - Elasticsearch implementation
- `/asset` - Media asset management
- `/events` - Event handling system
- `/loaders` - DataLoader pattern implementation

## Build Commands

### Code Generation
```
make generate        # Generate all code (SQLC and GraphQL)
make sqlc/.generated # Generate SQL code
make gql             # Generate all GraphQL code
make gql.api         # Generate API GraphQL code
make gql.admin       # Generate Admin GraphQL code
make gql.public      # Generate Public GraphQL code
```

### Building
```
make build           # Build all binaries
```

### Testing
```
go test ./...        # Run all tests
make test.elastic    # Run Elasticsearch tests
make test.integration # Run integration tests
```

### Running Locally
```
# Run API service
cd cmd/api && make run
# Run API with hot reload
cd cmd/api && make watch

# Run jobs service
cd cmd/jobs && make run
# Run jobs with hot reload
cd cmd/jobs && make watch
```

### Event Triggers
```
make topic.create              # Create PubSub topic
make topic.delete              # Delete PubSub topic
make event.search.reindex      # Trigger search reindex
make event.translations.sync   # Trigger translations sync
```

## Architecture

### API Server
- Built on Gin web framework with GraphQL using gqlgen
- Multiple GraphQL schemas/endpoints:
  - `/query`: Main API endpoint
  - `/admin`: Admin-specific operations
  - `/public`: Public-facing API
- Authentication via Auth0
- Role-based access control

### Database Access
- Uses sqlc for type-safe SQL queries
- PostgreSQL database
- Follows DataLoader pattern for efficient data access
- Redis for caching and distributed locking

### Event Processing
- Event-driven architecture for content updates
- Support for webhook events and scheduled tasks
- Background processing via jobs service

### Media Management
- S3 integration for asset storage
- CDN configuration for content delivery
- Video manipulation capabilities
- Support for timed metadata

### External Integrations
- Auth0 for authentication
- AWS services (S3, MediaPackage)
- Push notifications
- Translation services (Phrase)

## Environment Setup
The application is configured via environment variables. Sample environment files are provided:
- `/cmd/api/env.sample`
- `/cmd/jobs/env.sample`

Copy these to `.env` files in the respective directories and update with appropriate values.

## Common Development Workflows

1. When adding a new database field:
   - Add the field to the appropriate database table
   - Update SQL queries in sqlc
   - Run `make sqlc/.generated`
   - Update GraphQL schemas as needed
   - Run `make gql`

2. When adding a new GraphQL field:
   - Update the schema in `/graph/api/schema/`
   - Run `make gql.api`
   - Implement the resolver in the appropriate file

3. When working with events:
   - Register handlers in the appropriate event handler
   - Use the events package to publish events

4. Testing with external services:
   - Use dependency injection patterns to mock external services
   - Use the testutils package for common testing utilities