package loaders

import "github.com/ansel1/merry/v2"

const (
	ErrorCodeNotFound = "not-found"
)

func errNotFound(id any) error {
	return merry.Sentinel(ErrorCodeNotFound, merry.WithValue("id", id))
}
