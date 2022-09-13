
install:
	psql -h localhost -p 5432 -U btv postgres < ./special/00-reset.sql
	goose postgres "user=btv dbname=btv port=5432 host=localhost sslmode=disable" up
	psql -h localhost -p 5432 -U btv btv < ./special/01-admin-user.sql
