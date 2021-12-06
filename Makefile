help: .PHONY
	echo "Read the Makefile, im too lazy"

dependencies: .PHONY
	npm install -g pnpm
	go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
	go install github.com/kyleconroy/sqlc/cmd/sqlc@latest

local-setup: .PHONY
	cp backend/.env.example backend/.env
	cd local-setup && docker-compose up -d
	make migrate
	cd local-setup && docker-compose down
	cd frontend/admin && pnpm install

admin-frontend: .PHONY
	cd ./frontend/admin/ && pnpm start
	
admin-backend: .PHONY
	cd ./backend/admin/ && go run .

m:  .PHONY
	@echo migrate -database "postgres://postgres:password@localhost:5432/postgres?sslmode=disable" -path ./backend/db/migrations

migrate: .PHONY
	migrate -database "postgres://postgres:password@localhost:5432/postgres?sslmode=disable" -path ./backend/db/migrations up

mock: .PHONY
	mock-dev custom -f ./backend/db/mock/mock_skeleton.yaml --database postgres -v --password password

test-build: .PHONY
	docker build -t brunstadtv-admin-test:latest -f ./backend/Dockerfile.test ./backend --progress=plain

test: .PHONY
	make test-build
	cd backend && go test ./... -v