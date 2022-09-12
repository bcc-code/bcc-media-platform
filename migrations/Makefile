.PHONY: init install

install:
	npm install -g pg-diff-cli
	go install github.com/pressly/goose/v3/cmd/goose@latest

init: 
	psql -h localhost -p 5432 -U btv < ./special/00-reset.sql
	goose postgres "user=builder dbname=btv port=5432 host=localhost sslmode=disable" up
	psql -h localhost -p 5432 -U btv btv < ./special/01-admin-user.sql