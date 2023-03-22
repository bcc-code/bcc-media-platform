package auth0

// UserInfo contains information about a user
type UserInfo struct {
	UserId        string `json:"user_id"`
	Email         string `json:"email"`
	EmailVerified bool   `json:"email_verified"`
	Username      string `json:"username"`
	PhoneNumber   string `json:"phone_number"`
	PhoneVerified bool   `json:"phone_verified"`
	CreatedAt     string `json:"created_at"`
	UpdatedAt     string `json:"updated_at"`
	Identities    []struct {
		Connection string `json:"connection"`
		UserId     string `json:"user_id"`
		Provider   string `json:"provider"`
		IsSocial   bool   `json:"isSocial"`
	} `json:"identities"`
	AppMetadata struct {
	} `json:"app_metadata"`
	UserMetadata UserMetadata `json:"user_metadata"`
	Picture      string       `json:"picture"`
	Name         string       `json:"name"`
	Nickname     string       `json:"nickname"`
	Multifactor  []string     `json:"multifactor"`
	LastIp       string       `json:"last_ip"`
	LastLogin    string       `json:"last_login"`
	LoginsCount  int          `json:"logins_count"`
	Blocked      bool         `json:"blocked"`
	GivenName    string       `json:"given_name"`
	FamilyName   string       `json:"family_name"`
}

// UserMetadata is the user metadata
type UserMetadata struct {
	BirthYear       int  `json:"birth_year"`
	BirthMonth      int  `json:"birth_month"`
	MediaSubscriber bool `json:"media_subscriber"`
}
