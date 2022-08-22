package common

// Permissions contains permissions that restrict access to items
type Permissions struct {
	ItemID       int
	Type         ItemType
	Availability Availability
	Roles        Roles
}
