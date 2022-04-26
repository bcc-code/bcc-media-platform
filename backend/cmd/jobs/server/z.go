package server

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

type dbStats struct {
	ping  bool
	stats sql.DBStats
}

// ZDBStatus returns some status about the DB
// This is for monitroing purposes
func (s server) ZDBStatus(c *gin.Context) {
	ctx := c.Request.Context()

	err := s.rawDB.PingContext(ctx)
	stats := s.rawDB.Stats()

	c.JSON(http.StatusOK, gin.H{
		"ping":      err != nil,
		"idle":      stats.Idle,
		"used":      stats.InUse,
		"open":      stats.OpenConnections,
		"waitCount": stats.WaitCount,
		"waitTime":  fmt.Sprintf("%s", stats.WaitDuration),
	})
}
