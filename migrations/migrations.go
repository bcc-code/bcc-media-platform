package migrations

import (
	"embed"
)

//go:embed *.sql
var Migrations embed.FS

//go:embed special/pre/*.sql
var PreMigrations embed.FS

//go:embed special/post/*.sql
var PostMigrations embed.FS
