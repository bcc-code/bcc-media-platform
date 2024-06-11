#! /bin/bash

CB="run-deploy.yaml"
ROUTE="run-route.yaml"
M="migrations.yaml"

function deploy {
	echo "- name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'" >> $CB
	echo "  waitFor: ['-']" >> $CB
	echo "  entrypoint: gcloud" >> $CB
	echo "  args: ['run', 'deploy', '\$_${1}_SERVICE', '--project', '\$_PROJECT_ID', '--no-traffic', '--image', '$(cat ${2})', '--region', 'europe-west4']" >> $CB
}

function route {
	echo "- name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'" >> $ROUTE
	echo "  waitFor: ['-']" >> $ROUTE
	echo "  entrypoint: gcloud" >> $ROUTE
	echo "  args: ['run', 'services',  'update-traffic', '\$_${1}_SERVICE', '--to-latest', '--region=europe-west4']" >> $ROUTE
}

function migrations {
	echo "- name: ${1}" >> $M
	echo "  args: []" >> $M
	echo "  env:" >> $M
	echo "    - 'INSTANCE_CONNECTION_NAME=\$_INSTANCE_CONNECTION_NAME'" >> $M
	echo "  secretEnv: ['PGPASSWORD']" >> $M
	echo "availableSecrets:" >> $M
	echo "  secretManager:" >> $M
	echo "  - versionName: projects/\$PROJECT_ID/secrets/postgres_builder_password/versions/latest" >> $M
	echo "    env: 'PGPASSWORD'"  >> $M
}

function allow_loose {
	echo "options:" >> $1
	echo "   substitution_option: 'ALLOW_LOOSE'" >> $1
}

artifact pull workflow api.txt || true
artifact pull workflow jobs.txt || true
artifact pull workflow rewriter.txt || true
artifact pull workflow videomanipulator.txt || true
artifact pull workflow cms.txt || true
artifact pull workflow migrations.txt

# We always have migrations
echo "steps:" > $M
migrations $(cat migrations.txt)
artifact push workflow $M

if [ ! -f "api.txt" ] && [ ! -f "jobs.txt" ] && [ ! -f "cms.txt" ] && [ ! -f "rewriter.txt" ]; then
	# Nothing to do here, skip making workflows
	exit 0
fi

allow_loose $CB
echo "steps:" >> $CB

allow_loose $ROUTE
echo "steps:" >> $ROUTE

if [ -f "api.txt" ]; then
	deploy API api.txt
	route API api.txt
fi

if [ -f "jobs.txt" ]; then
	deploy JOBS jobs.txt
	route JOBS jobs.txt
fi

if [ -f "rewriter.txt" ]; then
	deploy REWRITER rewriter.txt
	route REWRITER rewriter.txt
fi

if [ -f "videomanipulator.txt" ]; then
	deploy VIDEOMANIPULATOR videomanipulator.txt
	route VIDEOMANIPULATOR videomanipulator.txt
fi

if [ -f "cms.txt" ]; then
	deploy CMS cms.txt
	route CMS cms.txt
fi

artifact push workflow $CB
artifact push workflow $ROUTE
