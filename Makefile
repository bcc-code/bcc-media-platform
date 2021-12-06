.PHONY:help
help:
	echo "Read the Makefile, im too lazy"

.PHONY:dependencies
dependencies:
	npm install -g pnpm
	go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
	go install github.com/kyleconroy/sqlc/cmd/sqlc@latest

.PHONY:local-setup
local-setup:
	cp backend/.env.example backend/.env
	cd local-setup && docker-compose up -d
	make migrate
	cd local-setup && docker-compose down
	cd frontend/admin && pnpm install

.PHONY:admin-frontend
admin-frontend:
	cd ./frontend/admin/ && pnpm start
	
.PHONY:admin-backend
admin-backend:
	cd ./backend/admin/ && go run .

.PHONY:m
m: 
	@echo migrate -database "postgres://postgres:password@localhost:5432/postgres?sslmode=disable" -path ./backend/db/migrations

.PHONY:migrate
migrate:
	migrate -database "postgres://postgres:password@localhost:5432/postgres?sslmode=disable" -path ./backend/db/migrations up

.PHONY:mock
mock:
	mock-dev custom -f ./backend/db/mock/mock_skeleton.yaml --database postgres -v --password password

.PHONY:test-build
test-build:
	docker build -t brunstadtv-admin-test:latest -f ./backend/Dockerfile.test ./backend --progress=plain

.PHONY:test
test:
	make test-build
	cd backend && go test ./... -v