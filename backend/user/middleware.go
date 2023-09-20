package user

import (
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/gin-gonic/gin"
)

// All well-known roles as used in the DB
const (
	RolePublic       = "public"
	RoleRegistered   = "registered"
	RoleBCCMember    = "bcc-members"
	RoleNonBCCMember = "non-bcc-members"
)

// Various hardcoded keys
const (
	CtxUser          = "ctx-user"
	CacheRoles       = "roles"
	CtxLanguages     = "ctx-languages"
	CtxImpersonating = "ctx-impersonating"
	CtxProfiles      = "ctx-profiles"
	CtxProfile       = "ctx-profile"
)

// GetAcceptedLanguagesFromCtx as sent by the user
func GetAcceptedLanguagesFromCtx(ctx *gin.Context) []string {
	accLang := ctx.GetHeader("Accept-Language")
	return utils.ParseAcceptLanguage(accLang)
}

// AgeGroups contains the different age groups keyed by the minimum age.
var AgeGroups = map[int]string{
	65: "65+",
	51: "51 - 64",
	37: "37 - 50",
	26: "26 - 36",
	19: "19 - 25",
	13: "13 - 18",
	10: "10 - 12",
	0:  "0 - 9",
}

// GetFromCtx gets the user stored in the context by the middleware
func GetFromCtx(ctx *gin.Context) *common.User {
	u, ok := ctx.Get(CtxUser)
	if !ok {
		return nil
	}

	return u.(*common.User)
}

// GetProfileFromCtx returns the current profile
func GetProfileFromCtx(ctx *gin.Context) *common.Profile {
	p, ok := ctx.Get(CtxProfile)
	if !ok {
		return nil
	}
	return p.(*common.Profile)
}

// GetProfilesFromCtx returns the current profile
func GetProfilesFromCtx(ctx *gin.Context) []common.Profile {
	p, ok := ctx.Get(CtxProfiles)
	if !ok {
		return nil
	}
	return p.([]common.Profile)
}

// GetLanguagesFromCtx as provided in the request
func GetLanguagesFromCtx(ctx *gin.Context) []string {
	l, ok := ctx.Get(CtxLanguages)
	if !ok {
		return []string{}
	}

	return l.([]string)
}
