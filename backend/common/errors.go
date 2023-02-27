package common

import (
	"github.com/ansel1/merry/v2"
)

func withCode(code string) merry.Wrapper {
	return merry.WithValue("code", code)
}

func newError(code string, internal string, public string) error {
	return merry.Sentinel(internal, withCode(code), merry.WithUserMessage(public))
}

// Errors
var (
	ErrItemNotFound         = newError("item/not-found", "item not found", "Item not found!")
	ErrProfileNotSet        = newError("user/not-authenticated", "profile not set / user unauthenticated", "You must be authenticated for this to work!")
	ErrItemNotPublished     = newError("item/not-published", "item is not published", "Item is not published!")
	ErrItemNoAccess         = newError("item/no-access", "user has no access to this item", "You do not have access to this item!")
	ErrTaskAlreadyCompleted = newError("task/already-completed", "task was already completed", "Task is already completed!")
	ErrInvalidUUID          = newError("uuid/invalid", "invalid uuid passed", "UUID is invalid!")
)
