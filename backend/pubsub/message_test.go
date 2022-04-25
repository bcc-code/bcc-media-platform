package pubsub

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestHmac(t *testing.T) {
	msg := Message{
		Message: Msg{
			Attributes: map[string]string{
				"hash": "9gsFQqSYb3yC7DoukqpcZfeISuVh6UcdCcbyB6C9juI=",
			},
			Data:        "W3sicGVyc29uSUQiOjU0NTMxLCJlbWFpbCI6Im1hdGphei5kZWJlbGFrQGJjYy5tZWRpYSIsImZpcnN0TmFtZSI6IkJydW5zdGFkIFRWIiwibGFzdE5hbWUiOiJUZXN0IFVzZXIiLCJtaWRkbGVOYW1lIjoiIiwiZGlzcGxheU5hbWUiOiJCcnVuc3RhZCBUViBUZXN0IFVzZXIiLCJnZW5kZXJDb2RlIjoxLCJiaXJ0aERhdGUiOiIxOTg4LTAxLTAxVDAwOjAwOjAwLjAwMFoiLCJjaHVyY2hJRCI6NjksImNodXJjaCI6eyJhY3RpdmUiOnRydWUsIm9yZyI6eyJjaHVyY2hJRCI6NjksIm5hbWUiOiJPc2xvL0ZvbGxvIiwib3JnSUQiOjY5LCJ2aXNpdGluZ0FkZHJlc3MiOnsiYWRkcmVzczEiOiJSeWVuc3R1YmJlbiAyIiwiYWRkcmVzczIiOiIwNjc5IE9zbG8iLCJhZGRyZXNzMyI6bnVsbCwiYWRkcmVzczQiOm51bGwsImNpdHkiOm51bGwsImNvdW50cnkiOnsiY291bnRyeUd1aWQiOiI0NGFhZjUyYi1iMGRmLWU5MTEtYTgxMi0wMDBkM2EyNWM1ZDYiLCJjb3VudHJ5SUQiOjUzLCJpc28yQ29kZSI6Im5vIiwibmFtZUVuIjoiTm9yd2F5IiwibmFtZU5hdGl2ZSI6Ik5vcmdlIiwibmFtZU5vIjoiTm9yZ2UifSwicG9zdGFsQ29kZSI6bnVsbH19LCJzdGFydERhdGUiOiIyMDIxLTA4LTI2VDExOjI4OjM2LjYxNFoifSwibGFzdENoYW5nZWREYXRlIjoiMjAyMS0wOC0yN1QwNzoyNDo0NC43NjFaIn1d",
			MessageID:   "2894600402015313",
			PublishTime: time.Time{},
		},
		Subscription: "projects/bcc-members-webhook-service/subscriptions/beta-1362378521-sub",
	}

	res := msg.Validate("ieChai8OphiSiek7chahkeidui3iya")
	assert.True(t, res)
}

func TestHmac_fail(t *testing.T) {
	msg := Message{
		Message: Msg{
			Attributes: map[string]string{
				"hash": "9gsFQqSYb3yC7DoukqpcZfeISuVh6UcdCcbyB6C9juI=",
			},
			Data:        "W3sicGVyc29uSUQiOjU0NTMxLCJlbWFpbCI6Im1hdGphei5kZWJlbGFrQGJjYy5tZWRpYSIsImZpcnN0TmFtZSI6IkJydW5zdGFkIFRWIiwibGFzdE5hbWUiOiJUZXN0IFVzZXIiLCJtaWRkbGVOYW1lIjoiIiwiZGlzcGxheU5hbWUiOiJCcnVuc3RhZCBUViBUZXN0IFVzZXIiLCJnZW5kZXJDb2RlIjoxLCJiaXJ0aERhdGUiOiIxOTg4LTAxLTAxVDAwOjAwOjAwLjAwMFoiLCJjaHVyY2hJRCI6NjksImNodXJjaCI6eyJhY3RpdmUiOnRydWUsIm9yZyI6eyJjaHVyY2hJRCI6NjksIm5hbWUiOiJPc2xvL0ZvbGxvIiwib3JnSUQiOjY5LCJ2aXNpdGluZ0FkZHJlc3MiOnsiYWRkcmVzczEiOiJSeWVuc3R1YmJlbiAyIiwiYWRkcmVzczIiOiIwNjc5IE9zbG8iLCJhZGRyZXNzMyI6bnVsbCwiYWRkcmVzczQiOm51bGwsImNpdHkiOm51bGwsImNvdW50cnkiOnsiY291bnRyeUd1aWQiOiI0NGFhZjUyYi1iMGRmLWU5MTEtYTgxMi0wMDBkM2EyNWM1ZDYiLCJjb3VudHJ5SUQiOjUzLCJpc28yQ29kZSI6Im5vIiwibmFtZUVuIjoiTm9yd2F5IiwibmFtZU5hdGl2ZSI6Ik5vcmdlIiwibmFtZU5vIjoiTm9yZ2UifSwicG9zdGFsQ29kZSI6bnVsbH19LCJzdGFydERhdGUiOiIyMDIxLTA4LTI2VDExOjI4OjM2LjYxNFoifSwibGFzdENoYW5nZWREYXRlIjoiMjAyMS0wOC0yN1QwNzoyNDo0NC43NjFaIn1d",
			MessageID:   "2894600402015313",
			PublishTime: time.Time{},
		},
		Subscription: "projects/bcc-members-webhook-service/subscriptions/beta-1362378521-sub",
	}

	res := msg.Validate("BADKEY")
	assert.False(t, res)
}

func TestHmac_noHash(t *testing.T) {
	msg := Message{
		Message: Msg{
			Attributes:  map[string]string{},
			Data:        "W3sicGVyc29uSUQiOjU0NTMxLCJlbWFpbCI6Im1hdGphei5kZWJlbGFrQGJjYy5tZWRpYSIsImZpcnN0TmFtZSI6IkJydW5zdGFkIFRWIiwibGFzdE5hbWUiOiJUZXN0IFVzZXIiLCJtaWRkbGVOYW1lIjoiIiwiZGlzcGxheU5hbWUiOiJCcnVuc3RhZCBUViBUZXN0IFVzZXIiLCJnZW5kZXJDb2RlIjoxLCJiaXJ0aERhdGUiOiIxOTg4LTAxLTAxVDAwOjAwOjAwLjAwMFoiLCJjaHVyY2hJRCI6NjksImNodXJjaCI6eyJhY3RpdmUiOnRydWUsIm9yZyI6eyJjaHVyY2hJRCI6NjksIm5hbWUiOiJPc2xvL0ZvbGxvIiwib3JnSUQiOjY5LCJ2aXNpdGluZ0FkZHJlc3MiOnsiYWRkcmVzczEiOiJSeWVuc3R1YmJlbiAyIiwiYWRkcmVzczIiOiIwNjc5IE9zbG8iLCJhZGRyZXNzMyI6bnVsbCwiYWRkcmVzczQiOm51bGwsImNpdHkiOm51bGwsImNvdW50cnkiOnsiY291bnRyeUd1aWQiOiI0NGFhZjUyYi1iMGRmLWU5MTEtYTgxMi0wMDBkM2EyNWM1ZDYiLCJjb3VudHJ5SUQiOjUzLCJpc28yQ29kZSI6Im5vIiwibmFtZUVuIjoiTm9yd2F5IiwibmFtZU5hdGl2ZSI6Ik5vcmdlIiwibmFtZU5vIjoiTm9yZ2UifSwicG9zdGFsQ29kZSI6bnVsbH19LCJzdGFydERhdGUiOiIyMDIxLTA4LTI2VDExOjI4OjM2LjYxNFoifSwibGFzdENoYW5nZWREYXRlIjoiMjAyMS0wOC0yN1QwNzoyNDo0NC43NjFaIn1d",
			MessageID:   "2894600402015313",
			PublishTime: time.Time{},
		},
		Subscription: "projects/bcc-members-webhook-service/subscriptions/beta-1362378521-sub",
	}

	res := msg.Validate("ieChai8OphiSiek7chahkeidui3iya")
	assert.False(t, res)
}

func TestHmac_moddedContent(t *testing.T) {
	msg := Message{
		Message: Msg{
			Attributes: map[string]string{
				"hash": "9gsFQqSYb3yC7DoukqpcZfeISuVh6UcdCcbyB6C9juI=",
			},
			Data:        "BAD CONTENT",
			MessageID:   "2894600402015313",
			PublishTime: time.Time{},
		},
		Subscription: "projects/bcc-members-webhook-service/subscriptions/beta-1362378521-sub",
	}

	res := msg.Validate("ieChai8OphiSiek7chahkeidui3iya")
	assert.False(t, res)
}
