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
	if os.Getenv("ENVIRONMENT") != "development" {
		gin.SetMode(gin.ReleaseMode)
	}
	router := gin.Default()
	apiKey := os.Getenv("API_KEY")

	if strings.TrimSpace(apiKey) == "" {
		panic("API_KEY environment variable is required")
	}

	router.Use(func(c *gin.Context) {
		a := c.GetHeader("x-api-key")
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

		if input.VideoUrl == "" || input.Seconds < 0 {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
			return
		}

		logLevel := "debug"
		if os.Getenv("ENVIRONMENT") != "development" {
			logLevel = "error"
		}

		cmd := exec.Command("ffmpeg", "-loglevel", logLevel, "-ss", fmt.Sprintf("%.2f", input.Seconds), "-i", input.VideoUrl, "-q:v", "1", "-frames:v", "1", "-c:v", "mjpeg", "-f", "image2pipe", "-")
		cmd.Stderr = os.Stderr
		output, err := cmd.Output()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.Data(http.StatusOK, "image/jpeg", output)

	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8005"
	}

	router.Run(fmt.Sprintf(":%s", port))
}
