help: .PHONY
	echo "Read the Makefile, im too lazy"

migrate:
	migrate -database "postgres://postgres:password@localhost:5432/vod?sslmode=disable" -path ./backend/db/migrations up
