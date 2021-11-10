help: .PHONY
	echo "Read the Makefile, im too lazy"

migrate:
	migrate -database "postgres://postgres:password@localhost:5432/vod?sslmode=disable" -path ./backend/db/migrations up

mock:
	mock-dev custom -f ./backend/db/mock/mock_skeleton.yaml --database vod -v --password password

run-admin-backend:
	cd ./backend/admin/ && go run .

test:
	docker build -t brunstadtv-admin-test:latest -f ./backend/Dockerfile.test ./backend --progress=plain
	cd backend && go test ./...