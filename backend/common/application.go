package common

import (
	"fmt"
	"strings"

	"github.com/ansel1/merry/v2"
	"github.com/gin-gonic/gin"
)

// CtxApp is the context key containing application
const (
	CtxApp = "app"
)

// GetApplicationFromCtx returns the stored application object from context
func GetApplicationFromCtx(ctx *gin.Context) (*Application, error) {
	entry, ok := ctx.Get(CtxApp)
	if !ok {
		return nil, merry.New("Application is not in context")
	}
	app, ok := entry.(*Application)
	if !ok {
		return nil, merry.New("Application was incorrectly set in context")
	}
	return app, nil
}

// GroupSlug is the application group label normalized for use as a key or prefix.
func (i Application) GroupSlug() string {
	return strings.ReplaceAll(strings.ToLower(strings.TrimSpace(i.GroupLabel)), " ", "-")
}

// ComputedRoles expands the user roles with variants prefixed by the
// application code and by the normalized application group label,
// e.g. "bcc-members" -> "kids-mobile-bcc-members", "bible-kids-bcc-members".
func (i Application) ComputedRoles(userRoles []string) []string {
	groupPrefix := i.GroupSlug()

	roles := append([]string{}, userRoles...)
	for _, r := range userRoles {
		roles = append(roles, fmt.Sprintf("%s-%s", i.Code, r))
		if groupPrefix != "" {
			roles = append(roles, fmt.Sprintf("%s-%s", groupPrefix, r))
		}
	}
	return roles
}
