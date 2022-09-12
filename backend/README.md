# Background jobs

The background jobs system is used for tasks like ingesting VOD files, and other
batch type jobs that may take a while.

It is triggered using PubSub messages and is meant to run on GoogleCloud Run platform.

Read more about how to run it and how to set up a dev environment [here](cmd/jobs/README.md).
