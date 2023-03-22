package members

type result[t any] struct {
	Data t `json:"data"`
}

// Member is a member with related data
type Member struct {
	PersonID      int
	Age           int
	Email         string
	EmailVerified bool   `json:"emailVerified"`
	DisplayName   string `json:"displayName"`
	FirstName     string `json:"firstName"`
	Gender        string `json:"gender"`
	Affiliations  []Affiliation
}

// Affiliation is an affiliation to an entity
type Affiliation struct {
	Active    bool
	OrgID     int
	OrgType   string
	Type      string
	ValidFrom string
	ChurchID  int
}

// Organization contains organizational data
type Organization struct {
	OrgID int
	Name  string `json:"districtName"`
	Type  string
}
