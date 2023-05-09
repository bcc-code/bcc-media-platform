install:
	cd ./interface-query-builder && npm ci
	cd ./interface-video-viewer && npm ci
	cd ./interface-datepicker && npm ci
	cd ./endpoint-preview && pnpm i
	cd ./hook-sync-to-legacy && pnpm i
	cd ./hook-pubsub && pnpm i

build:
	cd ./interface-query-builder && npm run build
	cd ./interface-video-viewer && npm run build
	cd ./interface-datepicker && npm run build
	cd ./endpoint-preview && pnpm build
	cd ./hook-sync-to-legacy && pnpm build
	cd ./hook-pubsub && pnpm build

init:
	cd ./interface-query-builder && npm i
	cd ./interface-video-viewer && npm i
	cd ./interface-datepicker && npm i
	cd ./endpoint-preview && pnpm i
	cd ./hook-sync-to-legacy && pnpm i
	cd ./hook-pubsub && pnpm i
	make build
