package members

type result[t any] struct {
	Data t `json:"data"`
}

// Member is a member with related data
type Member struct {
	PersonID    int
	Age         int
	Email       string
	DisplayName string
}
