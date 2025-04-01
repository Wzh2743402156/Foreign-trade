package routes

import (
	"backend/handlers"
	"github.com/gin-gonic/gin"
)

func RegisterAuthRoutes(r *gin.Engine) {
	r.POST("/api/login", handlers.LoginHandler)
}
