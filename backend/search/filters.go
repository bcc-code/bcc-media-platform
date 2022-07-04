package search

import (
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/gin-gonic/gin"
	"strings"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func (service *Service) getFiltersForUser(ctx *gin.Context) (string, error) {
	u := user.GetFromCtx(ctx)

	if len(u.Roles) == 0 {
		// No roles == no permissions == no results
		return "", merry.New("Missing roles")
	}
	now := time.Now().Unix()

	filters := []string{
		strings.Join(lo.Map(u.Roles, func(role string, _ int) string {
			return fmt.Sprintf("%s:%s", rolesField, role)
		}), " OR "),
		fmt.Sprintf("%s < %d", publishedAtField, now),
		fmt.Sprintf("%[1]s = 0 OR %[1]s < %[2]d", availableFromField, now),
		fmt.Sprintf("%[1]s = 0 OR %[1]s > %[2]d", availableToField, now),
		fmt.Sprintf("%s:%s", statusField, common.StatusPublished),
	}

	return "(" + strings.Join(filters, ") AND (") + ")", nil
}
