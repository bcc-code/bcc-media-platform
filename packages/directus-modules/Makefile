install:
	cd ./interface-query-builder && pnpm i
	cd ./interface-video-viewer && pnpm i
	cd ./interface-datepicker && pnpm i
	cd ./endpoint-preview && pnpm i
	cd ./hook-sync-to-legacy && pnpm i
	cd ./hook-pubsub && pnpm i
	cd ./panel-api-tools && pnpm i

build:
	cd ./interface-query-builder && pnpm build
	cd ./interface-video-viewer && pnpm build
	cd ./interface-datepicker && pnpm build
	cd ./endpoint-preview && pnpm build
	cd ./hook-sync-to-legacy && pnpm build
	cd ./hook-pubsub && pnpm build
	cd ./panel-api-tools && pnpm build

init:
	make install
	make build
