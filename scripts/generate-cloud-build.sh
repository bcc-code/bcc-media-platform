#! /bin/bash

artifact pull workflow api.txt || echo ""
artifact pull workflow jobs.txt || echo ""
artifact pull workflow cms.txt || echo ""

CB="run-deploy.yaml"
echo "steps:" > $CB

ROUTE="run-route.yaml"
echo "steps:" > $ROUTE

function deploy {
	echo "- name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'" >> $CB
	echo "  waitFor: ['-']" >> $CB
	echo "  entrypoint: gcloud" >> $CB
	echo "  args: ['run', 'deploy', '\$_${1}_SERVICE', '--image', '$(cat ${2})', '--region', 'europe-west4', '--no-traffic']" >> $CB
}

function route {
	echo "- name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'" >> $ROUTE
	echo "  waitFor: ['-']" >> $ROUTE
	echo "  entrypoint: gcloud" >> $ROUTE
	echo "  args: ['run', 'services',  'update-traffic', '\$_${1}_SERVICE', '--to-latest', '--region=europe-west4']" >> $ROUTE
}

if [ -f "api.txt" ]; then
	deploy API api.txt
	route API api.txt
fi

if [ -f "jobs.txt" ]; then
	deploy JOBS jobs.txt
	route JOBS jobs.txt
fi

if [ -f "cms.txt" ]; then
	deploy CMS cms.txt
	route CMS cms.txt
fi

artifact push workflow $CB
artifact push workflow $ROUTE
