package utils

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func RequestIDMiddleware(c *gin.Context) {
	// get the X-Request-ID header
	requestID := c.GetHeader("X-Request-ID")

	// if it is blank add it to the request
	if requestID == "" {
		c.Request.Header.Set("X-Request-ID", uuid.NewString())
	}

	// set the request id on the return
	c.Header("X-Request-ID", requestID)
}
