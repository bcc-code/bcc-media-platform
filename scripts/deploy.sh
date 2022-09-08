#! /bin/bash
set -Eeuo pipefail

ENV=$1

artifact pull workflow run-deploy.yaml
artifact pull workflow run-route.yaml
artifact pull workflow migrations.yaml

# Deploy images
gcloud builds submit \
	--project="btv-platform-${ENV}-2" \
	--no-source \
	--substitutions=_API_SERVICE=api-${ENV},_JOBS_SERVICE=background-worker-${ENV},_CMS_SERVICE=directus-${ENV} \
	--config=run-deploy.yaml

# Run migrations
gcloud builds submit \
	--project="btv-platform-${ENV}-2" \
	--no-source \
	--substitutions=_INSTANCE_CONNECTION_NAME=btv-platform-${ENV}-2:europe-west4:main-instance \
	--config=migrations.yaml

# Route Traffic
gcloud builds submit \
	--project="btv-platform-${ENV}-2" \
	--no-source \
	--substitutions=_API_SERVICE=api-${ENV},_JOBS_SERVICE=background-worker-${ENV},_CMS_SERVICE=directus-${ENV} \
	--config=run-route.yaml
