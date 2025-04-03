package routes

import (
	"backend/handlers"
	"backend/middleware"
	"github.com/gin-gonic/gin"
)

func RegisterUserRoutes(r *gin.Engine) {
	// 所有用户登录后才能访问的接口
	user := r.Group("/api/user")
	user.Use(middleware.JWTAuth())
	{
		user.GET("/profile", handlers.GetUserDetail)
	}
}
