#! /bin/bash

CB="run-deploy.yaml"
ROUTE="run-route.yaml"
M="migrations.yaml"

services=("API api.txt" "JOBS jobs.txt" "REWRITER rewriter.txt" "VIDEOMANIPULATOR videomanipulator.txt" "CMS cms.txt")

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

artifact pull workflow migrations.txt

# We always have migrations
echo "steps:" > $M
migrations $(cat migrations.txt)
artifact push workflow $M

# Pull files
SHOULD_DEPLOY=false
for service in "${services[@]}"; do
	file=$(echo $service | cut -d' ' -f2)
	artifact pull workflow $file || true
	if [ -f "$file" ]; then
		SHOULD_DEPLOY=true
	fi
done

# Quit if no services to deploy
if [ "$SHOULD_DEPLOY" = false ]; then
	exit 0
fi

allow_loose $CB
echo "steps:" >> $CB

allow_loose $ROUTE
echo "steps:" >> $ROUTE

for service in "${services[@]}"; do
    name=$(echo $service | cut -d' ' -f1)
    file=$(echo $service | cut -d' ' -f2)

    if [ -f "$file" ]; then
        deploy $name $file
        route $name $file
    fi
done

artifact push workflow $CB
artifact push workflow $ROUTE
