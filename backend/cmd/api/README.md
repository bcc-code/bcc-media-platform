# API

## Environment

Environment variables should be defined in `env.sample`. These should be configured and exposed to the process for the API to work.

## Graph

The API is exposed as a graphql endpoint on `/query`

It is built based on the schemas in [graph](../graph/schema), and generated with gqlgen.

## Admin

Another endpoint for administrative capabilities like preview is defined in the [graphadmin](../graphadmin) package.
