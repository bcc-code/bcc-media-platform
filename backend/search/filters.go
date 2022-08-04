package search

import (
	"fmt"
	"strings"
	"time"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func (service *Service) getFiltersForUser(u *common.User) (string, error) {
	now := time.Now().Unix()

	filters := []string{
		strings.Join(lo.Map(u.Roles, func(role string, _ int) string {
			return fmt.Sprintf("%s:%s", rolesField, role)
		}), " OR "),
		fmt.Sprintf("%s:true", publishedField),
		fmt.Sprintf("%[1]s = 0 OR %[1]s < %[2]d", availableFromField, now),
		fmt.Sprintf("%[1]s = 0 OR %[1]s > %[2]d", availableToField, now),
	}

	return "(" + strings.Join(filters, ") AND (") + ")", nil
}
