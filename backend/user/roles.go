package user

import "github.com/gin-gonic/gin"

// CtxRoles context key for roles
const CtxRoles = "roles"

// GetRolesFromCtx returns the roles stored in context
func GetRolesFromCtx(ctx *gin.Context) []string {
	return ctx.GetStringSlice(CtxRoles)
}
