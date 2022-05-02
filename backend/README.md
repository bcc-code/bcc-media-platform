## Requirements

This system uses Docker in order to spin up some services that are required for local development,
but some services need to use the real thing, as they are hard to emulate to any useful extent.

Please note that using real services in AWS, GCP, or other cloud providers may and will incur costs
for you!

Local emulators (docker):

* Google PubSub - Using HTTP push, so the emulator needs to have access to the local instance

Live services:

* AWS S3 - Can be emulated but MediaPackage requires the data to be in the cloud
* AWS MediaPackage - No suitable emulator available

## Manual installation

### Sqlc

Sqlc manages the "sqlc" folder
The sqlc.yaml file mostly is because I wanted to use guregu instead of sql.Null-whatever.

```
go install github.com/kyleconroy/sqlc/cmd/sqlc@latest
sqlc generate
```
