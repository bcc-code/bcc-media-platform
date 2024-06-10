#! /bin/bash
set -Eeuo pipefail

ENV=$1

artifact pull workflow run-deploy.yaml || true
artifact pull workflow run-route.yaml || true
artifact pull workflow migrations.yaml

if [ -f "run-deploy.yaml" ]; then
	# Deploy images
	gcloud builds submit \
		--project="btv-platform-${ENV}-2" \
		--no-source \
		--substitutions="_PROJECT_ID=btv-platform-${ENV}-2,_API_SERVICE=api-${ENV},_JOBS_SERVICE=background-worker-${ENV},_CMS_SERVICE=directus-${ENV},_REWRITER_SERVICE=rewriter-${ENV},_VIDEOMANIPULATOR_SERVICE=videomanipulator-${ENV}" \
		--config=run-deploy.yaml
fi

# Run migrations
gcloud builds submit \
	--project="btv-platform-${ENV}-2" \
	--no-source \
	--substitutions=_INSTANCE_CONNECTION_NAME=btv-platform-${ENV}-2:europe-west4:main-instance \
	--config=migrations.yaml

if [ -f "run-route.yaml" ]; then
	# Route Traffic
	gcloud builds submit \
		--project="btv-platform-${ENV}-2" \
		--no-source \
		--substitutions=_API_SERVICE=api-${ENV},_JOBS_SERVICE=background-worker-${ENV},_CMS_SERVICE=directus-${ENV},_REWRITER_SERVICE=rewriter-${ENV},_VIDEOMANIPULATOR_SERVICE=videomanipulator-${ENV} \
		--config=run-route.yaml
fi
