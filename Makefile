help: .PHONY
	echo "Read the Makefile, im too lazy"

migrate:
	migrate -database "postgres://postgres:password@localhost:5432/postgres?sslmode=disable" -path ./backend/db/migrations up

mock:
	mock-dev custom -f ./backend/db/mock/mock_skeleton.yaml --database postgres -v --password password

run-admin-backend:
	cd ./backend/admin/ && go run .

test-build:
	docker build -t brunstadtv-admin-test:latest -f ./backend/Dockerfile.test ./backend --progress=plain

test:
	make test-build
	cd backend && go test ./... -v