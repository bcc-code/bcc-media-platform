package common

// Permissions contains permissions that restrict access to items
type Permissions[k comparable] struct {
	ItemID       k
	Type         ItemCollection
	Availability Availability
	Roles        Roles
}
