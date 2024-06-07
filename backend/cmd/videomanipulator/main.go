package main

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"strings"

	"github.com/bcc-code/bcc-media-platform/backend/videomanipulator"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	apiKey := os.Getenv("API_KEY")

	if strings.TrimSpace(apiKey) == "" {
		panic("API_KEY environment variable is required")
	}

	router.Use(func(c *gin.Context) {
		a := c.GetHeader("X-API-Key")
		if a != apiKey {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid API Key"})
			c.Abort()
			return
		}
		c.Next()
	})

	router.POST("/image", func(c *gin.Context) {
		var input videomanipulator.GenerateImageForUrlParams
		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		cmd := exec.Command("ffmpeg", "-ss", fmt.Sprintf("%.2f", input.Seconds), "-i", input.VideoUrl, "-q:v", "1", "-frames:v", "1", "-f", "image2", "-")
		pipe, err := cmd.StdoutPipe()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		if err := cmd.Start(); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.DataFromReader(http.StatusOK, -1, "image/jpeg", pipe, map[string]string{})
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8005"
	}

	router.Run(fmt.Sprintf(":%s", os.Getenv("PORT")))
}
