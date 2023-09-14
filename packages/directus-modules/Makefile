install:
	cd ./interface-query-builder && pnpm i
	cd ./interface-video-viewer && pnpm i
	cd ./interface-datepicker && pnpm i
	cd ./interface-timedmetadata-tools && pnpm i
	cd ./endpoint-tools && pnpm i
	cd ./hook-pubsub && pnpm i
	cd ./panel-api-tools && pnpm i

build:
	cd ./interface-query-builder && pnpm build
	cd ./interface-video-viewer && pnpm build
	cd ./interface-datepicker && pnpm build
	cd ./interface-timedmetadata-tools && pnpm build
	cd ./endpoint-tools && pnpm build
	cd ./hook-pubsub && pnpm build
	cd ./panel-api-tools && pnpm build

update:
	cd ./interface-query-builder && pnpm update
	cd ./interface-video-viewer && pnpm update
	cd ./interface-datepicker && pnpm update
	cd ./interface-timedmetadata-tools && pnpm update
	cd ./endpoint-tools && pnpm update
	cd ./hook-pubsub && pnpm update
	cd ./panel-api-tools && pnpm update

init:
	make install
	make build
