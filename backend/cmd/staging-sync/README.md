# Staging Sync

This executable can be used to sync data from PROD to STAGING.

It requires some configuration, but should only copy the public schema to the staging database.

## Configuration

Needs the [Cloud SQL Auth Proxy](https://cloud.google.com/sql/docs/postgres/sql-proxy) somewhere.

Specify the path with `AUTH_PROXY_PATH` in the environment.

See [.env.example](.env.example) for the other required environment variables.

Use `_AUTH_PROXY_CONFIG` to specify if a proxy should be started and configured.

Should look something like this:

`{projectId}:europe-west4:main-instance=tcp:localhost:{port}`

The connection string associated with this should also have the same address configuration.
