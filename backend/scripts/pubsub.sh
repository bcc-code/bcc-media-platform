#! /bin/bash
docker run --rm -it -p 8681:8681  \
	--name pubsub \
	thekevjames/gcloud-pubsub-emulator:latest


