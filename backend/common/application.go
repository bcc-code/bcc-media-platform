package common

import (
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
