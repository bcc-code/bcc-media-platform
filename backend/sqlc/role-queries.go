package sqlc

// RoleQueries contains role specific queries
type RoleQueries struct {
	queries *Queries
	roles   []string
}

// RoleQueries returns methods with multiple queries
func (q *Queries) RoleQueries(roles []string) *RoleQueries {
	return &RoleQueries{
		queries: q,
		roles:   roles,
	}
}
