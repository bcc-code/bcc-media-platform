package common

// User represents an actual user in the system
type User struct {
	DisplayName   string
	Roles         []string
	Email         string
	EmailVerified bool
	PersonID      string
	Anonymous     bool
	ActiveBCC     bool
	AgeGroup      string
	ChurchIDs     []int
	Age           int
}

// IsAnonymous user?
func (u User) IsAnonymous() bool {
	return u.Anonymous
}

// IsRegistered user?
func (u User) IsRegistered() bool {
	return !u.Anonymous
}

// IsActiveBCC user?
func (u User) IsActiveBCC() bool {
	return !u.Anonymous && u.ActiveBCC
}
