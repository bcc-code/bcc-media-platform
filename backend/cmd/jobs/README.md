# Background jobs

## Pre-Requirements

You must have a functional AWS account.
In the aws account you need to set up a new Role as described in [AWS Docs](https://docs.aws.amazon.com/mediapackage/latest/ug/setting-up-create-trust-rel.html).
The ARN for the role needs to be entered into the `AWS_MEDIAPACKAGE_ROLE` env var.
Next you need to set up a packaging group in AWS MediaPackage VOD and enter it's id under `AWS_PACKAGING_GROUP`.

In addition you also need 2 buckets: One for ingest and one for storing the data.

An Directus instance with an active API key and correct schema is also required.

## Config

The environment variables in use are listed in `./env.sample` file. How you inject them into the environment is up to you.

## External services

This system uses Docker in order to spin up some services that are required for local development,
but some services need to use the real thing, as they are hard to emulate to any useful extent.

Please note that using real services in AWS, GCP, or other cloud providers may and will incur costs
for you!

Local emulators (docker):

* Google PubSub - Using HTTP push, so the emulator needs to have access to the local instance

Live services:

* AWS S3 - Can be emulated but MediaPackage requires the data to be in the cloud
* AWS MediaPackage - No suitable emulator available

## Development

Configure your env (see `./env.sample`)

Make sure the auxiliary services are started
`cd ../../../ && docker-compose up`

Make sure your Directus instance is started up to date and configured

Then run the watcher
`make watch`


